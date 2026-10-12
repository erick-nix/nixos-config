{
  ...
}:

{
  imports = [
    ../common
    ./modules/packages.nix
  ];

  home = {
    username = "erick-nix";
    homeDirectory = "/home/erick-nix";
    stateVersion = "26.05";

    file = {
      ".config/background" = {
        source = ./assets/wallpaper.webp;
        force = true;
      };
      ".face".source = ./assets/avatar.png;
    };
  };
}
