{ pkgs, lib, ... }:

{
  services = {
    desktopManager = {
      gnome.enable = true;
    };

    displayManager = {
      gdm.enable = true;
      defaultSession = "gnome";
    };

    gnome = {
      core-apps.enable = true;
      core-developer-tools.enable = false;
      games.enable = true;
    };
  };

  environment = {
    systemPackages = with pkgs; [
      gnome-themes-extra
      gnome-extension-manager
      gnomeExtensions.clipboard-indicator
      gnomeExtensions.appindicator
      gnomeExtensions.status-area-horizontal-spacing
      gnomeExtensions.quick-settings-audio-panel
      gnomeExtensions.alphabetical-app-grid
      gnomeExtensions.hide-accessibility-menu
    ];

    gnome.excludePackages = with pkgs; [
      cheese
      atomix
      epiphany
      evince
      geary
      gedit
      gnome-characters
      gnome-music
      gnome-terminal
      gnome-tour
      totem
    ];

    # Correction: https://github.com/NixOS/nixpkgs/issues/195936
    sessionVariables.GST_PLUGIN_SYSTEM_PATH_1_0 = lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" (
      with pkgs.gst_all_1;
      [
        gst-plugins-good
        gst-plugins-bad
        gst-plugins-ugly
        gst-libav
      ]
    );
  };

  programs = {
    dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
            cursor-theme = "Adwaita";
            font-name = "Adwaita Sans 11";
            icon-theme = "Adwaita";
            gtk-theme = "Adwaita-dark";
          };

          "org/gnome/desktop/wm/preferences" = {
            button-layout = "appmenu:minimize,maximize,close";
          };

          # keybindings
          "org/gnome/desktop/wm/keybindings" = {
            close = [ "<Super>w" ];
          };

          "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
            name = "Open Terminal";
            command = "ghostty";
            binding = "<Super>x";
          };

          "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
            name = "Open Files";
            command = "nautilus";
            binding = "<Super>e";
          };

          "org/gnome/settings-daemon/plugins/media-keys" = {
            custom-keybindings = [
              "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
              "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
            ];
          };
        };
      }
    ];
  };
}
