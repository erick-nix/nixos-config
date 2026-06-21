{
  ...
}:

{
  programs = {
    vscodium.enable = true;
    ghostty = {
      enable = true;
      settings = {
        language = "br";
        theme = "Iceberg Dark";
        font-family = "Cascadia Code";
        font-size = 12;
        adjust-cell-height = "60%";
        shell-integration-features = "no-cursor";
        clipboard-read = "allow";
        clipboard-write = "allow";

        maximize = true;
        window-width = 118;
        window-height = 20;
        window-padding-x = 12;
        window-padding-y = 12;

        scrollback-limit = 10000;

        keybind = [
          # Neovim smooth scroll
          "shift+up=csi:1;2A"
          "shift+down=csi:1;2B"

          # Navigate between panes
          "ctrl+shift+left=goto_split:left"
          "ctrl+shift+right=goto_split:right"
          "ctrl+shift+up=goto_split:up"
          "ctrl+shift+down=goto_split:down"

          # Close current pane
          "ctrl+shift+w=close_surface"
        ];
      };
    };
  };
}
