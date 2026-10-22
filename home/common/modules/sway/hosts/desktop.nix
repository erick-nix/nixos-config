{
  lib,
  pkgs,
  hostname ? null,
  ...
}:

lib.mkIf (hostname == "desktop") {
  # Notifications on the second monitor
  services = {
    mako = {
      settings = {
        output = "DP-1";
      };
    };
  };

  wayland.windowManager.sway = {
    # Nvidia
    extraOptions = [ "--unsupported-gpu" ];

    config = {
      output."*".background = "${../../../../desktop/assets/wallpaper.webp} fill";

      workspaceOutputAssign = [
        {
          workspace = "1";
          output = "HDMI-A-1";
        }
        {
          workspace = "10";
          output = "DP-1";
        }
      ];

      output = {
        "HDMI-A-1" = {
          mode = "1920x1080@74.973Hz";
          position = "1080 840";
        };

        "DP-1" = {
          mode = "1920x1080@74.973Hz";
          position = "0 0";
          transform = "270";
        };
      };

      focus.newWindow = "none";

      startup = lib.mkOptionDefault [
        # KDE Connect
        {
          command = "${pkgs.kdePackages.kdeconnect-kde}/bin/kdeconnect-indicator";
        }
        # Load backlight - sleep to wait for second monitor
        {
          command = "sleep 5 && sudo ${pkgs.systemd}/bin/udevadm trigger --subsystem-match=i2c --action=add";
        }
      ];

      keybindings = lib.mkOptionDefault {
        "Mod1+x" = "exec ${pkgs.brillo}/bin/brillo -e -A 5";
        "Mod1+z" = "exec ${pkgs.brillo}/bin/brillo -e -U 5";
      };
    };
  };

  programs.waybar.settings.mainBar = {
    modules-right = [
      "custom/network"
      "disk#root"
      "backlight"
      "pulseaudio"
      "memory"
      "cpu"
      "custom/cpu_temp"
      "clock"
      "tray"
    ];
  };
}
