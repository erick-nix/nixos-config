{ pkgs, config, ... }:

{
  gtk = {
    enable = true;
    colorScheme = "dark";
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    gtk4.theme = config.gtk.theme;

    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
  };
}
