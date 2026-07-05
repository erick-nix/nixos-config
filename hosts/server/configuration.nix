{
  username,
  homeDir,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./modules
  ];

  users = {
    groups.media = { };
    users = {
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
          "romm"
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
  };

  # Home Manager configuration
  home-manager = {
    users.root.home.stateVersion = "25.11";
    users.${username} = import ../../home/server/server.nix;
    users.eduardo = import ../../home/server/moons/eduardo.nix;
    users.monica = import ../../home/server/moons/monica.nix;
  };
}
