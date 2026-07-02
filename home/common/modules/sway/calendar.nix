{ osConfig, ... }:

{
  accounts.calendar = {
    basePath = ".calendar";
    accounts.baikal = {
      primary = true;
      primaryCollection = "default";
      remote = {
        type = "caldav";
        url = "https://cal.erick-nix.com/dav.php/calendars/erick-nix/";
        userName = "erick-nix";
        passwordCommand = [
          "cat"
          osConfig.sops.secrets."baikal/caldav_password".path
        ];
      };

      khal = {
        enable = true;
        type = "discover";
        glob = "*";
      };
      vdirsyncer = {
        enable = true;
        auth = "digest";
        collections = [ "default" ];
      };
    };
  };

  programs.khal = {
    enable = true;
    settings.default.timedelta = "30d";
    locale = {
      local_timezone = "America/Sao_Paulo";
      default_timezone = "America/Sao_Paulo";
      firstweekday = 0;
      weeknumbers = "left";
      dateformat = "%d/%m/%Y";
      timeformat = "%H:%M";
      datetimeformat = "%d/%m/%Y %H:%M";
      longdateformat = "%A %d %B %Y";
      longdatetimeformat = "%A %d %B %Y %H:%M";
      unicode_symbols = true;
    };
  };

  programs.vdirsyncer.enable = true;
  services.vdirsyncer = {
    enable = true;
    frequency = "*:0/15";
  };
}
