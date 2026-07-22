{
  hostname,
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
    description = "Keep more-specific main-table routes ahead of the Tailscale exit-node default route";
    after = [ "tailscaled.service" ];
    wants = [ "tailscaled.service" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    path = [ pkgs.iproute2 ];

    script = ''
      ip rule add pref 200 table main suppress_prefixlength 0 || true
    '';

    preStop = ''
      ip rule del pref 200 table main suppress_prefixlength 0 || true
    '';
  };
}
