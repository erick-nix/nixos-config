{ ... }:

{
  xdg = {
    mimeApps = {
      enable = true;

      defaultApplications = {
        "image/png" = [ "imv.desktop" ];
        "image/jpeg" = [ "imv.desktop" ];
        "image/webp" = [ "imv.desktop" ];
        "image/gif" = [ "imv.desktop" ];
        "image/bmp" = [ "imv.desktop" ];
        "image/tiff" = [ "imv.desktop" ];
        "image/avif" = [ "imv.desktop" ];
        "image/svg+xml" = [ "imv.desktop" ];
      };
    };

    desktopEntries.imv = {
      name = "imv";
      exec = "imv %F";
      terminal = false;
      type = "Application";
      categories = [
        "Graphics"
        "Viewer"
      ];
    };
  };
}
