{ domain, ... }:

{
  networking = {
    firewall = {
      allowedTCPPorts = [
        8443 # Crafty Control
        25565 # Minecraft
      ];

      allowedUDPPorts = [
        25565 # Minecraft
      ];
    };
  };

  services.caddy = {
    virtualHosts = {
      "bento.${domain}".extraConfig = ''
        reverse_proxy 127.0.0.1:8888
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

  virtualisation.oci-containers = {
    backend = "docker";

    containers = {
      bentopdf = {
        autoStart = true;
        image = "ghcr.io/alam00000/bentopdf-simple:sha-b71d6c9";

        ports = [
          "8888:8080"
        ];
      };

      crafty = {
        image = "arcadiatechnology/crafty-4:4.10.6";
        autoStart = true;

        ports = [
          "8443:8443" # Crafty Web UI (HTTPS)
          "25565:25565" # Minecraft (default)
        ];

        volumes = [
          "/srv/crafty/backups:/crafty/backups"
          "/srv/crafty/logs:/crafty/logs"
          "/srv/crafty/servers:/crafty/servers"
          "/srv/crafty/config:/crafty/app/config"
        ];
      };

    };
  };
}
