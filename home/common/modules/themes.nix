{ pkgs, ... }:

{
  # GTK
  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";

  gtk = {
    enable = true;
    colorScheme = "dark";
    gtk4.theme = null;

    theme = {
      name = "Adwaita";
      package = pkgs.gnome-themes-extra;
    };

    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
  };

  # QT
  qt = {
    enable = true;
    style.name = "adwaita-dark";
    platformTheme.name = "adwaita";
  };
}
