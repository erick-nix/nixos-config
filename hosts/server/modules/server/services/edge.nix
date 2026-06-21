{
  config,
  pkgs,
  domain,
  ...
}:

{
  services = {
    # Cloudflared
    # NOTE: cloudflared tunnel route dns server some.${domain}
    cloudflared = {
      enable = true;
      tunnels = {
        server = {
          credentialsFile = config.sops.secrets."cloudflare/tunnel".path;
          ingress = {
            "ssh.${domain}" = "ssh://localhost:22";
          };
          default = "http_status:404";
        };
      };
    };

    # Caddy
    caddy = {
      enable = true;
      environmentFile = config.sops.secrets."caddy/environment".path;
      package = pkgs.caddy.withPlugins {
        plugins = [ "github.com/caddy-dns/cloudflare@v0.2.4" ];
        hash = "sha256-8yZDrejNKsaUnUaTUFYbarWNmxafqp2z2rWo+XRsxV8=";
      };

      extraConfig = ''
        *.${domain} {
          tls {
            dns cloudflare {env.CLOUDFLARE_API_TOKEN}
          }
        }
      '';

      virtualHosts = {
        "vault.${domain}".extraConfig = ''
          encode zstd gzip
          reverse_proxy 127.0.0.1:8222 {
            header_up X-Real-IP {remote_host}
          }
        '';

        "bento.${domain}".extraConfig = ''
          reverse_proxy 127.0.0.1:8888
        '';

        "kanboard.${domain}".extraConfig = ''
          reverse_proxy 127.0.0.1:8081
        '';

        "jellyfin.${domain}".extraConfig = ''
          reverse_proxy 127.0.0.1:8096
        '';

        "git.${domain}".extraConfig = ''
          reverse_proxy 127.0.0.1:8788
        '';

        "status.${domain}".extraConfig = ''
          reverse_proxy 127.0.0.1:8095
        '';

        "search.${domain}".extraConfig = ''
          reverse_proxy 127.0.0.1:8887
        '';

        "suwayomi.${domain}".extraConfig = ''
          reverse_proxy 127.0.0.1:4567
        '';

        "immich.${domain}".extraConfig = ''
          reverse_proxy 127.0.0.1:2283
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

        "syncthing.${domain}".extraConfig = ''
          reverse_proxy 127.0.0.1:8384
        '';

        "home.${domain}".extraConfig = ''
          reverse_proxy 127.0.0.1:3000
        '';

        "crafty.${domain}".extraConfig = ''
          reverse_proxy https://127.0.0.1:8443 {
            transport http {
                tls_insecure_skip_verify
            }
          }
        '';
      };
    };
  };
}
