{ username, homeDir, ... }:

let
  caddyFile = ../../secrets/hosts/server/caddy.yaml;
  cloudflareFile = ../../secrets/hosts/server/cloudflare.yaml;
  glanceFile = ../../secrets/hosts/server/glance.yaml;
  vaultwardenFile = ../../secrets/hosts/server/vaultwarden.yaml;
  searxFile = ../../secrets/hosts/server/searx.yaml;
in

{
  imports = [
    ./hardware-configuration.nix
    ./modules
    ./modules/server
  ];

  users.users = {
    # Main user
    ${username} = {
      home = homeDir;
      isNormalUser = true;
      description = "Manutenção";
      extraGroups = [
        "wheel"
        "networkmanager"
        "docker"
        "media"
      ];

      # cat ~/.ssh/id_ed25519.pub
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFTNNEYC7PFQq1+yR26cevr+NyuI+wK58+tbCCdAc+it erick-nix@desktop"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAAjsYUmp4xBj18yVogTpJex4+kwnWnW9NcOgHAmHwpX erick-nix@laptop"
      ];
    };

    # Moons
    eduardo = {
      home = "/home/eduardo";
      isNormalUser = true;
      description = "Mãe";
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
    };

    monica = {
      home = "/home/monica";
      isNormalUser = true;
      description = "Irmã";
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
    };
  };

  users.groups.media = { };
  users.users.jellyfin.extraGroups = [ "media" ];

  # Home Manager configuration
  home-manager = {
    users.root.home.stateVersion = "25.11";
    users.${username} = import ../../home/server/server.nix;
    users.eduardo = import ../../home/server/moons/eduardo.nix;
    users.monica = import ../../home/server/moons/monica.nix;
  };

  # Secrets
  sops.secrets."cloudflare/tunnel".sopsFile = cloudflareFile;
  sops.secrets."caddy/environment".sopsFile = caddyFile;
  sops.secrets."glance/environment".sopsFile = glanceFile;
  sops.secrets."vaultwarden/environment".sopsFile = vaultwardenFile;
  sops.secrets."searx/secret_key".sopsFile = searxFile;
}
