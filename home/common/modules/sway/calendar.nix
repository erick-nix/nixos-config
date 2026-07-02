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
    locale = {
      dateformat = "%d/%m/%Y";
      longdateformat = "%d/%m/%Y";
    };
  };

  programs.vdirsyncer.enable = true;
  services.vdirsyncer = {
    enable = true;
    frequency = "*:0/15";
  };
}
