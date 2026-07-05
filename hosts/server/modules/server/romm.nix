{
  config,
  username,
  domain,
  ...
}:

let
  rommFile = ../../../../secrets/hosts/server/romm.yaml;
in

{
  users = {
    users = {
      ${username} = {
        extraGroups = [
          "romm"
        ];
      };
    };
    groups.romm = { };
  };

  systemd = {
    tmpfiles.rules = [
      "d /srv/romm 2775 root romm - -"
      "d /srv/romm/library 2775 root romm - -"
      "Z /srv/romm/library - root romm - -"
    ];
  };

  sops.secrets."romm/env" = {
    sopsFile = rommFile;
    key = "romm/env";
  };

  sops.secrets."romm/db_env" = {
    sopsFile = rommFile;
    key = "romm/db_env";
  };

  services.caddy = {
    virtualHosts = {
      "rom.${domain}".extraConfig = ''
        reverse_proxy 127.0.0.1:4243
      '';
    };
  };

  virtualisation.oci-containers = {
    containers = {
      romm-db = {
        image = "mariadb:latest";
        autoStart = true;

        environment = {
          MARIADB_DATABASE = "romm";
          MARIADB_USER = "romm-user";
        };

        environmentFiles = [ config.sops.secrets."romm/db_env".path ];

        volumes = [
          "/srv/romm/mysql_data:/var/lib/mysql"
        ];

        extraOptions = [
          "--health-cmd=healthcheck.sh --connect --innodb_initialized"
          "--health-start-period=30s"
          "--health-interval=10s"
          "--health-timeout=5s"
          "--health-retries=5"
        ];
      };

      romm = {
        image = "rommapp/romm:latest";
        autoStart = true;
        dependsOn = [ "romm-db" ];

        environment = {
          DB_HOST = "romm-db";
          DB_NAME = "romm";
          DB_USER = "romm-user";
          HASHEOUS_API_ENABLED = "true";
        };

        environmentFiles = [ config.sops.secrets."romm/env".path ];

        volumes = [
          "/srv/romm/resources:/romm/resources"
          "/srv/romm/redis_data:/redis-data"
          "/srv/romm/library:/romm/library"
          "/srv/romm/assets:/romm/assets"
          "/srv/romm/config:/romm/config"
        ];

        ports = [
          "4243:8080"
        ];

        extraOptions = [
          "--link=romm-db:romm-db"
        ];
      };
    };
  };
}
