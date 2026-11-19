{
  lib,
  pkgs,
  hostname ? null,
  ...
}:

let
  brightctl = pkgs.writeShellApplication {
    name = "brightctl";
    runtimeInputs = with pkgs; [
      ddcutil
      gawk
      findutils
      gnugrep
      util-linux
      coreutils
    ];
    text = builtins.readFile ../../../../../scripts/brightctl.sh;
  };
in

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
        "*" = {
          adaptive_sync = "on";
          background = "${../../../../desktop/assets/wallpaper.webp} fill";
        };

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
      ];

      keybindings = lib.mkOptionDefault {
        "Mod1+x" = "exec ${brightctl}/bin/brightctl up 12";
        "Mod1+z" = "exec ${brightctl}/bin/brightctl down 12";
      };
    };
  };

  programs.waybar.settings.mainBar = {
    modules-right = [
      "network"
      "disk#root"
      "pulseaudio"
      "memory"
      "cpu"
      "custom/cpu_temp"
      "clock"
      "tray"
    ];
  };
}
