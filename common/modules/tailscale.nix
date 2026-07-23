{
  hostname,
  username,
  pkgs,
  lib,
  ...
}:

let
  isServer = hostname == "server";
in

{
  services.tailscale = {
    enable = true;

    useRoutingFeatures = if isServer then "both" else "client";

    extraSetFlags =
      (
        if isServer then
          [
            "--advertise-routes=192.168.1.0/24"
            "--advertise-exit-node"
          ]
        else
          [ ]
      )
      ++ [
        "--accept-routes"
      ];

    extraUpFlags = lib.optionals (!isServer) [
      "--exit-node=server"
      "--exit-node-allow-lan-access"
    ];
  };

  systemd.services.tailscale-preserve-main-routes = lib.mkIf (!isServer) {
    description = "Keep more-specific main-table routes ahead of the Tailscale exit-node default route, and let the novpn.slice cgroup bypass the exit-node entirely";
    after = [ "tailscaled.service" ];
    wants = [ "tailscaled.service" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    path = [
      pkgs.iproute2
      pkgs.iptables
      pkgs.coreutils
    ];

    script = ''
      ip rule add pref 200 table main suppress_prefixlength 0 || true

      novpn_uid=$(id -u ${username})
      novpn_parent="/sys/fs/cgroup/user.slice/user-''${novpn_uid}.slice/user@''${novpn_uid}.service"
      novpn_cgroup="user.slice/user-''${novpn_uid}.slice/user@''${novpn_uid}.service/novpn.slice"

      if [ -d "$novpn_parent" ]; then
        mkdir -p "/sys/fs/cgroup/$novpn_cgroup"
        chown -R ${username}: "/sys/fs/cgroup/$novpn_cgroup"

        iptables -t mangle -C OUTPUT -m cgroup --path "$novpn_cgroup" -j MARK --set-mark 0x100 2>/dev/null \
          || iptables -t mangle -A OUTPUT -m cgroup --path "$novpn_cgroup" -j MARK --set-mark 0x100

        iptables -t nat -C POSTROUTING -m mark --mark 0x100 -j MASQUERADE 2>/dev/null \
          || iptables -t nat -A POSTROUTING -m mark --mark 0x100 -j MASQUERADE

        ip rule add pref 150 fwmark 0x100 lookup main || true
      fi
    '';

    preStop = ''
      ip rule del pref 200 table main suppress_prefixlength 0 || true
      ip rule del pref 150 fwmark 0x100 lookup main || true

      novpn_uid=$(id -u ${username})
      novpn_cgroup="user.slice/user-''${novpn_uid}.slice/user@''${novpn_uid}.service/novpn.slice"
      iptables -t mangle -D OUTPUT -m cgroup --path "$novpn_cgroup" -j MARK --set-mark 0x100 || true
      iptables -t nat -D POSTROUTING -m mark --mark 0x100 -j MASQUERADE || true
    '';
  };
}
