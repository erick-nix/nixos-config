{ ... }:

{
  xdg = {
    mimeApps = {
      enable = true;

      defaultApplications = {
        "application/pdf" = [ "librewolf.desktop" ];
        "text/html" = [ "librewolf.desktop" ];
        "application/xhtml+xml" = [ "librewolf.desktop" ];
        "x-scheme-handler/http" = [ "librewolf.desktop" ];
        "x-scheme-handler/https" = [ "librewolf.desktop" ];

        "image/png" = [ "imv.desktop" ];
        "image/jpeg" = [ "imv.desktop" ];
        "image/webp" = [ "imv.desktop" ];
        "image/gif" = [ "imv.desktop" ];
        "image/bmp" = [ "imv.desktop" ];
        "image/tiff" = [ "imv.desktop" ];
        "image/avif" = [ "imv.desktop" ];
        "image/svg+xml" = [ "imv.desktop" ];

        "video/mp4" = [ "vlc.desktop" ];
        "video/webm" = [ "vlc.desktop" ];
        "video/x-matroska" = [ "vlc.desktop" ];
        "video/x-msvideo" = [ "vlc.desktop" ];
        "video/quicktime" = [ "vlc.desktop" ];
        "video/mpeg" = [ "vlc.desktop" ];
        "video/ogg" = [ "vlc.desktop" ];
        "video/x-flv" = [ "vlc.desktop" ];
        "video/3gpp" = [ "vlc.desktop" ];
        "video/x-ms-wmv" = [ "vlc.desktop" ];
        "video/mp2t" = [ "vlc.desktop" ];
        "video/x-m4v" = [ "vlc.desktop" ];

        "text/plain" = [ "nvim-ghostty.desktop" ];
        "text/markdown" = [ "nvim-ghostty.desktop" ];
        "application/json" = [ "nvim-ghostty.desktop" ];
        "application/xml" = [ "nvim-ghostty.desktop" ];
        "text/xml" = [ "nvim-ghostty.desktop" ];
        "text/yaml" = [ "nvim-ghostty.desktop" ];
        "application/yaml" = [ "nvim-ghostty.desktop" ];
        "application/x-yaml" = [ "nvim-ghostty.desktop" ];
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

    desktopEntries.nvim-ghostty = {
      name = "Neovim (Ghostty)";
      exec = "ghostty -e nvim %F";
      terminal = false;
      type = "Application";
      categories = [
        "Utility"
        "TextEditor"
      ];
      mimeType = [
        "text/plain"
        "text/markdown"
        "application/json"
        "application/xml"
        "text/xml"
        "text/yaml"
        "application/yaml"
        "application/x-yaml"
      ];
    };
  };
}
