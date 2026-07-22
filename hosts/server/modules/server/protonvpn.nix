{
  config,
  pkgs,
  ...
}:

let
  protonFile = ../../../../secrets/hosts/server/protonvpn.yaml;
  protonTable = 51820;
in

{
  sops.secrets."protonvpn/private_key".sopsFile = protonFile;

  networking.wireguard.interfaces.proton0 = {
    ips = [ "10.2.0.2/32" ];
    privateKeyFile = config.sops.secrets."protonvpn/private_key".path;
    table = toString protonTable;

    peers = [
      {
        publicKey = "FopxTTklZx2W9X1ua1rGHdn+w4F8KVwcBjVmqMFFbAI=";
        endpoint = "195.181.162.163:51820";
        allowedIPs = [ "0.0.0.0/0" ];
        persistentKeepalive = 25;
      }
    ];
  };

  # Only packets forwarded in from tailscale0 (i.e. exit-node traffic from other
  # tailnet devices) get sent through proton0. The server's own traffic and
  # tailscale's control-plane traffic keep using the normal default route.
  systemd.services.proton0-routing = {
    description = "Route tailscale exit-node traffic through proton0";
    after = [
      "wireguard-proton0.service"
      "tailscaled.service"
    ];
    requires = [ "wireguard-proton0.service" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    path = [ pkgs.iproute2 ];

    script = ''
      ip rule add iif tailscale0 lookup ${toString protonTable} priority 100
      ip route replace default dev proton0 table ${toString protonTable}
    '';

    preStop = ''
      ip rule del iif tailscale0 lookup ${toString protonTable} priority 100 || true
    '';
  };

  # Asymmetric routing (in on tailscale0, out on proton0) trips the default
  # strict reverse-path filter.
  networking.firewall.checkReversePath = "loose";

  networking.nat = {
    enable = true;
    externalInterface = "proton0";
    internalInterfaces = [ "tailscale0" ];
  };
}
