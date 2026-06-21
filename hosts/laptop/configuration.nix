{ username, homeDir, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules
  ];

  # Main user
  users.users.${username} = {
    home = homeDir;
    isNormalUser = true;
    description = "Erick Henrique";
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
    ];
  };

  # Home Manager configuration
  home-manager = {
    users.root.home.stateVersion = "25.05";
    users.${username} = import ../../home/laptop/laptop.nix;
  };
}
