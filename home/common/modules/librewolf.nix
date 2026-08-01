{ pkgs, lib, ... }:

{
  programs = {
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
          "ui.key.menuAccessKeyFocuses" = false;
        };

        search = {
          force = true;
          engines =
            let
              nixIcon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";

              mkEngine =
                {
                  template,
                  params,
                  alias,
                  icon ? null,
                }:
                {
                  urls = [
                    {
                      inherit template;
                      params = lib.mapAttrsToList (name: value: { inherit name value; }) params;
                    }
                  ];
                  definedAliases = [ alias ];
                }
                // lib.optionalAttrs (icon != null) { inherit icon; };
            in
            {
              "Nix Packages" = mkEngine {
                template = "https://search.nixos.org/packages";
                params = {
                  channel = "unstable";
                  query = "{searchTerms}";
                };
                alias = "@np";
                icon = nixIcon;
              };

              "Nix Options" = mkEngine {
                template = "https://search.nixos.org/options";
                params = {
                  channel = "unstable";
                  query = "{searchTerms}";
                };
                alias = "@no";
                icon = nixIcon;
              };

              "Nix Issues" = mkEngine {
                template = "https://github.com/NixOS/nixpkgs/issues";
                params.q = "{searchTerms}";
                alias = "@ni";
                icon = nixIcon;
              };

              "Github" = mkEngine {
                template = "https://github.com/search";
                params.q = "{searchTerms}";
                alias = "@g";
              };
            };
        };
      };

      # Separate profile launched only via the "LibreWolf (noVPN)" .desktop entry
      profiles.novpn = {
        id = 1;
        isDefault = false;
        settings = {
          "privacy.resistFingerprinting" = false;
          "ui.key.menuAccessKeyFocuses" = false;
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

        # Use with pinnedExtension
        # ExtensionUpdate = false;

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
            # pinnedExtension = uuid: xpiUrl: {
            #   name = uuid;
            #   value = {
            #     install_url = xpiUrl;
            #     installation_mode = "force_installed";
            #     updates_disabled = true;
            #   };
            # };
          in
          listToAttrs [
            # Ex: (pinnedExtension "{446900e4-71c2-419f-a6a7-df9c091e268b}" "https://addons.mozilla.org/firefox/downloads/file/4875950/bitwarden_password_manager-2026.6.1.xpi")
            (extension "bitwarden-password-manager" "{446900e4-71c2-419f-a6a7-df9c091e268b}")
            (extension "darkreader" "addon@darkreader.org")
            (extension "augmented-steam" "{1be309c5-3e4f-4b99-927d-bb500eb4fa88}")
            (extension "sponsorblock" "sponsorBlocker@ajay.app")
            (extension "cookie-autodelete" "CookieAutoDelete@kennydo.com")
          ];

        "3rdparty".Extensions."uBlock0@raymondhill.net".toOverwrite.filterLists = [
          "user-filters"
          "ublock-filters"
          "ublock-badware"
          "ublock-privacy"
          "ublock-unbreak"
          "ublock-quick-fixes"
          "easylist"
          "easyprivacy"
          "urlhaus-1"
          "plowe-0"
          "spa-1"
          "adguard-social"
          "fanboy-social"
          "fanboy-thirdparty_social"
          "fanboy-cookiemonster"
          "ublock-cookies-easylist"
          "adguard-cookies"
          "ublock-cookies-adguard"
        ];
      };
    };
  };
}
