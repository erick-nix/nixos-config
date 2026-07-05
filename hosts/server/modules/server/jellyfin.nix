{ domain, ... }:

{
  users.users.jellyfin.extraGroups = [ "media" ];

  systemd = {
    services = {
      # Jellyfin disable IPV6
      jellyfin.environment = {
        DOTNET_SYSTEM_NET_DISABLEIPV6 = "1";
      };
    };
  };

  services = {
    caddy = {
      virtualHosts = {
        "jellyfin.${domain}".extraConfig = ''
          reverse_proxy 127.0.0.1:8096
        '';
      };
    };

    jellyfin = {
      enable = true;
      openFirewall = true;
    };
  };
}
