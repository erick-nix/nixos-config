{ username, ... }:

{
  systemd = {
    targets = {
      suspend.enable = false;
      hibernate.enable = false;
      hybrid-sleep.enable = false;
    };

    # sudo systemd-tmpfiles --create
    tmpfiles.rules = [
      "d /srv/media 2775 ${username} media -"
    ];

    services = {
      # Jellyfin disable IPV6
      jellyfin.environment = {
        DOTNET_SYSTEM_NET_DISABLEIPV6 = "1";
      };
    };
  };
}
