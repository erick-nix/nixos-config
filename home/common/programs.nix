{ config, ... }:

{
  programs = {
    vscodium.enable = true;

    firefox = {
      enable = true;
      configPath = "${config.xdg.configHome}/mozilla/firefox";

      policies = {
        # Updates & Background Services
        AppAutoUpdate = false;
        BackgroundAppUpdate = false;

        # Feature Disabling
        DisableFirefoxStudies = true;
        DisableFirefoxAccounts = true;
        DisableForgetButton = true;
        DisableMasterPasswordCreation = true;
        DisableProfileImport = true;
        DisableProfileRefresh = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DisableFormHistory = true;
        DisablePasswordReveal = true;

        # Browser extensions
        ExtensionSettings =
          with builtins;
          let
            extension = shortId: uuid: {
              name = uuid;
              value = {
                install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
                installation_mode = "normal_installed";
              };
            };
          in
          listToAttrs [
            (extension "ublock-origin" "uBlock0@raymondhill.net")
            (extension "bitwarden-password-manager" "{446900e4-71c2-419f-a6a7-df9c091e268b}")
            (extension "darkreader" "addon@darkreader.org")
            (extension "augmented-steam" "{1be309c5-3e4f-4b99-927d-bb500eb4fa88}")
            (extension "sponsorblock" "sponsorBlocker@ajay.app")
            (extension "videospeed" "{7be2ba16-0f1e-4d93-9ebc-5164397477a9}")
            (extension "youtube-recommended-videos" "myallychou@gmail.com")
          ];
      };
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
