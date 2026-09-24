{ config, domain, ... }:

let
  freshrssFile = ../../../../secrets/hosts/server/freshrss.yaml;
in

{
  sops.secrets."freshrss/password" = {
    sopsFile = freshrssFile;
    owner = config.services.freshrss.user;
  };

  services = {
    postgresql = {
      enable = true;
      ensureDatabases = [ "freshrss" ];
      ensureUsers = [
        {
          name = "freshrss";
          ensureDBOwnership = true;
        }
      ];
    };

    freshrss = {
      enable = true;
      virtualHost = "rss.${domain}";
      baseUrl = "https://rss.${domain}";
      webserver = "caddy";
      defaultUser = "admin";
      passwordFile = config.sops.secrets."freshrss/password".path;
    };
  };
}
