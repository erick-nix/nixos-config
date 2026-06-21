{
  config,
  lib,
  domain,
  ...
}:

{
  services = {
    # Ollama
    ollama = {
      enable = true;
      host = "0.0.0.0";
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
          # You need to specify this to remove the port from URLs in the web UI.
          ROOT_URL = "https://git.${domain}";
          HTTP_PORT = 8788;
        };
      };
    };

    # Jellyfin
    jellyfin = {
      enable = true;
      openFirewall = true;
    };

    # Immich
    immich = {
      enable = true;
      port = 2283;
      host = "0.0.0.0";
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

    # Vaultwarden
    vaultwarden = {
      enable = true;
      backupDir = "/var/local/vaultwarden/backup";
      environmentFile = config.sops.secrets."vaultwarden/environment".path;
      config = {
        domain = "https://vault.${domain}";
        SIGNUPS_ALLOWED = false;

        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = 8222;
        ROCKET_LOG = "critical";
      };
    };

    # Suwayomi Server
    suwayomi-server = {
      enable = true;
      openFirewall = true;
      settings = {
        server = {
          port = 4567;
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

    # Searx
    searx = {
      enable = true;
      redisCreateLocally = true;
      settings = {
        server = {
          base_url = "https://search.${domain}";
          bind_address = "0.0.0.0";
          port = 8887;
          secret_key = config.sops.secrets."searx/secret_key".path;
        };

        enabled_plugins = [
          "Tor check plugin"
          "Hostnames plugin"
        ];

        engines = lib.mapAttrsToList (name: value: { inherit name; } // value) {
          "startpage".disabled = true;
          "brave".disabled = true;
          "wikidata".disabled = true;
          "flickr".disabled = true;
          "brave.images".disabled = true;
          "duckduckgo images".disabled = true;
          "qwant images".disabled = true;
          "deviantart".disabled = true;
          "pexels".disabled = true;
          "artic".disabled = true;
          "unsplash".disabled = true;
          "openverse".disabled = true;
          "devicons".disabled = true;
          "lucide".disabled = true;
          "startpage images".disabled = true;
          "bing".disabled = false;
        };
      };
    };
  };
}
