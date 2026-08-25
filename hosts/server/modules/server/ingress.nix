{
  config,
  pkgs,
  domain,
  ...
}:

let
  caddyFile = ../../../../secrets/hosts/server/caddy.yaml;
  cloudflareFile = ../../../../secrets/hosts/server/cloudflare.yaml;
in

{
  sops.secrets."cloudflare/tunnel".sopsFile = cloudflareFile;
  sops.secrets."caddy/environment".sopsFile = caddyFile;

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
        hash = "sha256-PWadA5qr/gR2qDcT8l8u1Xku7LM2HIfWTLOkzezCYy0=";
      };

      extraConfig = ''
        *.${domain} {
          tls {
            dns cloudflare {env.CLOUDFLARE_API_TOKEN}
          }
        }
      '';
    };
  };
}
