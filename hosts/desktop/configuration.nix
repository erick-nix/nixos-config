{ username, homeDir, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules
  ];

  environment = {
    variables = {
      RUSTICL_ENABLE = "radeonsi";
    };
  };

  # Main user
  users.users.${username} = {
    home = homeDir;
    isNormalUser = true;
    description = "Erick Henrique";
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
      "fuse"
    ];
  };

  # Home Manager configuration
  home-manager = {
    users.root.home.stateVersion = "25.05";
    users.${username} = import ../../home/desktop/desktop.nix;
  };
}
