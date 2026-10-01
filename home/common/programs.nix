{ homeDir, ... }:

{
  programs = {
    vscodium.enable = true;

    direnv = {
      enable = true;
      silent = true;
      nix-direnv.enable = true;
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      history.size = 10000;
      history.ignoreAllDups = true;

      shellAliases = {
        ll = "ls -l";
        la = "ls -la";
        n = "nvim .";
        nr = "cd /etc/nixos && sudo env HOME=$HOME XDG_STATE_HOME=/root/.local/state XDG_CACHE_HOME=/root/.cache DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY WAYLAND_DISPLAY=$WAYLAND_DISPLAY XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR nvim .";
        b = "bluetui";
        y = "yazi";
        notes = "cd ${homeDir}/data/notes && nvim .";
        pm = "cd ${homeDir}/data/programming/projects";
        check-store = "nix-store --gc --print-dead | xargs du -shc 2>/dev/null | tail -n1";
      };

      initContent = ''
        source ${../../scripts/nr.sh}
        setopt HIST_IGNORE_SPACE
      '';
    };

    ghostty = {
      enable = true;
      settings = {
        language = "br";
        theme = "Iceberg Dark";
        font-family = "Cascadia Mono";
        font-size = 12;
        adjust-cell-height = "60%";
        shell-integration-features = "no-cursor";
        clipboard-read = "allow";
        clipboard-write = "allow";
        scrollback-limit = 100000;

        # Check if Ghostty added copy mode
        # https://github.com/ghostty-org/ghostty/discussions/3488

        gtk-toolbar-style = "flat";
        maximize = true;
        window-width = 118;
        window-height = 20;
        window-padding-x = 12;
        window-padding-y = 12;

        keybind = [
          # Navigate between panes
          # Cycle through panes by creation order (works reliably with
          # nested splits, unlike directional goto_split, which is buggy
          # with nested/stacked splits: https://github.com/ghostty-org/ghostty/discussions/12296)
          "ctrl+shift+left=goto_split:previous"
          "ctrl+shift+right=goto_split:next"
          "ctrl+shift+up=goto_split:previous"
          "ctrl+shift+down=goto_split:next"

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
