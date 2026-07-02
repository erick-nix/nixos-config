{ ... }:

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
        scrollback-limit = 100000;

        gtk-toolbar-style = "flat";
        maximize = true;
        window-width = 118;
        window-height = 20;
        window-padding-x = 12;
        window-padding-y = 12;

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

          # ThinkPad pt-br layout workaround for slash/question in Ghostty
          # https://github.com/ghostty-org/ghostty/discussions/5772
          "ctrl+shift+backspace=unbind"
          "ctrl+slash=text:/"
          "shift+ctrl+control_right=text:?"
        ];
      };
    };
  };
}
