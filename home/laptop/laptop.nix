{
  ...
}:

{
  imports = [
    ../common
    ../common/modules/dconf.nix
    ../common/modules/gaming.nix
    ../common/modules/calendar.nix
    ./modules/packages.nix
  ];

  home = {
    username = "erick-nix";
    homeDirectory = "/home/erick-nix";
    stateVersion = "25.05";

    file = {
      ".config/background" = {
        source = ./assets/wallpaper.webp;
        force = true;
      };
      ".face".source = ./assets/avatar.png;
    };
  };
}
