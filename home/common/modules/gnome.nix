{
  homeDir,
  ...
}:

{
  dconf.settings = {
    # Wallpaper and avatar
    "org/gnome/desktop/background" = {
      picture-uri = "file://${homeDir}/.config/background";
      picture-uri-dark = "file://${homeDir}/.config/background";
      picture-options = "zoom";
    };

    "org/gnome/desktop/screensaver" = {
      picture-uri = "file://${homeDir}/.config/background";
    };
  };
}
