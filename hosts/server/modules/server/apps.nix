{
  domain,
  config,
  ...
}:

{
  services = {
    caddy = {
      virtualHosts = {
        "kanboard.${domain}".extraConfig = ''
          reverse_proxy 127.0.0.1:8081
        '';

        "git.${domain}".extraConfig = ''
          reverse_proxy 127.0.0.1:8788
        '';

        "status.${domain}".extraConfig = ''
          reverse_proxy 127.0.0.1:8095
        '';

        "suwayomi.${domain}".extraConfig = ''
          reverse_proxy 127.0.0.1:4567
        '';

        "immich.${domain}".extraConfig = ''
          reverse_proxy 127.0.0.1:2283
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

    # Ollama
    ollama = {
      enable = true;
      host = "0.0.0.0";
      openFirewall = true;
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

    # Forgejo
    forgejo = {
      enable = true;
      settings = {
        server = {
          domain = "git.${domain}";
          ROOT_URL = "https://git.${domain}";
          HTTP_PORT = 8788;
        };
      };
    };

    # Immich
    immich = {
      enable = true;
      port = 2283;
      host = "0.0.0.0";
      openFirewall = true;
      # AMD
      accelerationDevices = [ "/dev/dri/renderD128" ];
    };

    # Kanboard
    kanboard = {
      enable = true;

      nginx.listen = [
        {
          addr = "127.0.0.1";
          port = 8081;
        }
      ];
    };

    # Suwayomi Server
    suwayomi-server = {
      enable = true;
      openFirewall = true;
      settings = {
        server = {
          port = 4567;
          webUIChannel = "PREVIEW";

          extensionRepos = [
            "https://raw.githubusercontent.com/keiyoushi/extensions/repo/index.min.json"
          ];
        };
      };
    };

    # Bbeszel (Status)
    beszel = {
      hub = {
        enable = true;
        host = "0.0.0.0";
        port = 8095;
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
  };
}
