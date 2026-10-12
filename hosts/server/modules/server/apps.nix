{
  domain,
  config,
  pkgs,
  pkgsUnstable,
  ...
}:

{
  services = {
    caddy = {
      virtualHosts = {
        "immich.${domain}".extraConfig = ''
          reverse_proxy 127.0.0.1:8001
        '';

        "git.${domain}".extraConfig = ''
          reverse_proxy 127.0.0.1:8002
        '';

        "status.${domain}".extraConfig = ''
          reverse_proxy 127.0.0.1:8003
        '';

        "translate.${domain}".extraConfig = ''
          reverse_proxy 127.0.0.1:8004
        '';

        "kanboard.${domain}".extraConfig = ''
          reverse_proxy 127.0.0.1:8005
        '';

        "rss.${domain}".extraConfig = ''
          reverse_proxy 127.0.0.1:8006
        '';

        "traccar.${domain}".extraConfig = ''
          reverse_proxy 127.0.0.1:8007
        '';

        "syncthing.${domain}".extraConfig = ''
          reverse_proxy 127.0.0.1:8384
        '';

        "cal.${domain}".extraConfig = ''
          root * ${config.services.baikal.package}/share/php/baikal/html
          encode zstd gzip
          @well_known path /.well-known/caldav /.well-known/carddav
          redir @well_known /dav.php 308

          @denied path_regexp denied ^/(\\.ht|Core|Specific|config)
          respond @denied 404

          php_fastcgi unix/${config.services.phpfpm.pools.baikal.socket}
          file_server
        '';
      };
    };

    # Immich
    immich = {
      enable = true;
      port = 8001;
      host = "0.0.0.0";
      openFirewall = true;
      package = pkgsUnstable.immich;
      accelerationDevices = [ "/dev/dri/renderD128" ];
    };

    # Forgejo
    forgejo = {
      enable = true;
      settings = {
        server = {
          domain = "git.${domain}";
          ROOT_URL = "https://git.${domain}";
          HTTP_PORT = 8002;
        };
      };
    };

    # Bbeszel (Status)
    beszel = {
      hub = {
        enable = true;
        host = "0.0.0.0";
        port = 8003;

        environment = {
          DISABLE_PASSWORD_AUTH = "true";
        };
      };

      agent = {
        enable = true;
        openFirewall = true;
        smartmon.enable = true;

        environment = {
          KEY = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMpB936yfvldXUE/nZpaujy3Z1lIL1aHRUZjrHykW2VV";
        };
      };
    };

    # LibreTranslate
    libretranslate = {
      enable = true;
      host = "0.0.0.0";
      port = 8004;
      configureNginx = false;
      updateModels = true;
      extraArgs = {
        load-only = "pt,en";
      };
    };

    # Kanboard
    kanboard = {
      enable = true;

      nginx.listen = [
        {
          addr = "127.0.0.1";
          port = 8005;
        }
      ];
    };

    # yarr
    yarr = {
      enable = true;
      port = 8006;
    };

    # Traccar
    traccar = {
      enable = true;
      settings = {
        web.port = "8007";

        # Only android (5055)
        protocols.enable = "osmand";
      };
    };

    # baikal
    baikal = {
      enable = true;
      virtualHost = null;
    };

    phpfpm.pools.baikal.settings = {
      "listen.owner" = "caddy";
      "listen.group" = "caddy";
      "listen.mode" = "0660";
    };

    # Bento PDF
    bentopdf = {
      enable = true;
      package = pkgs.bentopdf.override { simpleMode = true; };
      domain = "bento.${domain}";
      caddy.enable = true;
    };
  };
}
