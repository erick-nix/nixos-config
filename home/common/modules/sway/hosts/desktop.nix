{
  lib,
  pkgs,
  hostname ? null,
  ...
}:

lib.mkIf (hostname == "desktop") {
  services.wluma = {
    enable = false;
    settings = {
      als.time.thresholds = {
        "0" = "night";
        "8" = "day";
        "18" = "night";
      };

      output.backlight = [
        {
          name = "DP-2";
          path = "/sys/class/backlight/ddcci6";
          capturer = "wayland";
          predictor.manual.thresholds.day = {
            "0" = 0;
            "40" = 5;
            "60" = 10;
            "75" = 18;
          };
          predictor.manual.thresholds.night = {
            "0" = 0;
            "40" = 17;
            "60" = 31;
            "75" = 50;
          };
        }
        {
          name = "HDMI-A-1";
          path = "/sys/class/backlight/ddcci8";
          capturer = "wayland";
          predictor.manual.thresholds.day = {
            "0" = 0;
            "40" = 5;
            "60" = 10;
            "75" = 18;
          };
          predictor.manual.thresholds.night = {
            "0" = 0;
            "40" = 17;
            "60" = 31;
            "75" = 50;
          };
        }
      ];
    };
  };

  wayland.windowManager.sway.config = {
    workspaceOutputAssign = [
      {
        workspace = "1";
        output = "HDMI-A-1";
      }
      {
        workspace = "10";
        output = "DP-2";
      }
    ];

    output = {
      "DP-2" = {
        mode = "1920x1080@74.973Hz";
        position = "0 0";
        transform = "270";
      };

      "HDMI-A-1" = {
        mode = "1920x1080@74.973Hz";
        position = "1080 840";
      };
    };

    focus.newWindow = "none";

    keybindings = lib.mkOptionDefault {
      # Desktop external monitor brightness via ddcci backlight devices
      "Mod4+period" =
        "exec ${pkgs.bash}/bin/bash -lc 'for d in /sys/class/backlight/ddcci*; do [ -e \"$d\" ] || continue; ${pkgs.brightnessctl}/bin/brightnessctl -d \"$(basename \"$d\")\" set +8%; done'";
      "Mod4+comma" =
        "exec ${pkgs.bash}/bin/bash -lc 'for d in /sys/class/backlight/ddcci*; do [ -e \"$d\" ] || continue; ${pkgs.brightnessctl}/bin/brightnessctl -d \"$(basename \"$d\")\" set 8%-; done'";
    };
  };
}
