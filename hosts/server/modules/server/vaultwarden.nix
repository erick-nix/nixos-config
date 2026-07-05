{ domain, config, ... }:

let
  vaultwardenFile = ../../../../secrets/hosts/server/vaultwarden.yaml;
in

{
  sops.secrets."vaultwarden/environment".sopsFile = vaultwardenFile;

  services = {
    caddy = {
      virtualHosts = {
        "vault.${domain}".extraConfig = ''
          encode zstd gzip
          reverse_proxy 127.0.0.1:8222 {
            header_up X-Real-IP {remote_host}
          }
        '';
      };
    };

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
  };
}
