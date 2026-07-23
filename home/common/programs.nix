{ ... }:

{
  programs = {
    vscodium.enable = true;

    librewolf = {
      enable = true;

      # Swap RFP (all-or-nothing) for FPP with all targets enabled, so specific
      # sites can be carved out via overrides instead of disabling protection entirely.
      # https://codeberg.org/librewolf/issues/issues/2121
      # https://codeberg.org/librewolf/issues/issues/2598
      profiles.default = {
        id = 0;
        isDefault = true;
        settings = {
          "privacy.resistFingerprinting" = false;
          "privacy.fingerprintingProtection" = true;
          "privacy.fingerprintingProtection.pbmode" = true;
          "privacy.fingerprintingProtection.overrides" =
            "+AllTargets,-WindowDevicePixelRatio,-CSSPrefersColorScheme";
          "print.prefer_system_dialog" = true;
        };
      };

      # Separate profile launched only via the "LibreWolf (noVPN)" .desktop entry
      profiles.novpn = {
        id = 1;
        isDefault = false;
        settings = {
          "privacy.resistFingerprinting" = false;
        };
      };

      policies = {
        # Download
        PromptForDownloadLocation = true;

        # Don't force-upgrade http:// to https://
        HttpsOnlyMode = "disallowed";

        # Bookmarks
        DisplayBookmarksToolbar = "never";

        # Cookie AutoDelete extension handles cleanup instead
        SanitizeOnShutdown = {
          Cookies = false;
        };

        # Feature Disabling
        DisableForgetButton = true;
        DisableMasterPasswordCreation = true;
        DisableProfileImport = true;
        DisableProfileRefresh = true;
        DisableFormHistory = true;
        DisablePasswordReveal = true;

        # Search engine
        SearchEngines = {
          Default = "Search";
          Add = [
            {
              Name = "Search";
              URLTemplate = "https://search.erick-nix.com/search?q={searchTerms}";
              Method = "GET";
              IconURL = "https://search.erick-nix.com/favicon.ico";
            }
          ];
        };

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
            (extension "bitwarden-password-manager" "{446900e4-71c2-419f-a6a7-df9c091e268b}")
            (extension "darkreader" "addon@darkreader.org")
            (extension "augmented-steam" "{1be309c5-3e4f-4b99-927d-bb500eb4fa88}")
            (extension "sponsorblock" "sponsorBlocker@ajay.app")
            (extension "videospeed" "{7be2ba16-0f1e-4d93-9ebc-5164397477a9}")
            (extension "cookie-autodelete" "CookieAutoDelete@kennydo.com")
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
