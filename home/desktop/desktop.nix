{
  ...
}:

{
  imports = [
    ../common
    ./modules
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
