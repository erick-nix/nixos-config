{ ... }:

{
  systemd = {
    targets = {
      suspend.enable = false;
      hibernate.enable = false;
      hybrid-sleep.enable = false;
    };

    services = {
      # Jellyfin disable IPV6
      jellyfin.environment = {
        DOTNET_SYSTEM_NET_DISABLEIPV6 = "1";
      };
    };
  };
}
