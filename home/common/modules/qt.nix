{ pkgs, ... }:

{
  qt = {
    enable = true;
    style.name = "adwaita-dark";
    platformTheme = {
      name = "gtk3";
      # home-manager doesn't know how to auto-install a package for "gtk3";
      # the platformthemes/libqgtk3.so plugin lives inside qtbase itself.
      package = [
        pkgs.qt6.qtbase
        pkgs.libsForQt5.qt5.qtbase
      ];
    };
  };
}
