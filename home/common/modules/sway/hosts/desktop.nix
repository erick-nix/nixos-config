{
  lib,
  pkgs,
  hostname ? null,
  ...
}:

lib.mkIf (hostname == "desktop") {
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
      "Mod1+x" =
        "exec ${pkgs.bash}/bin/bash -lc 'for d in /sys/class/backlight/ddcci*; do [ -e \"$d\" ] || continue; ${pkgs.brightnessctl}/bin/brightnessctl -d \"$(basename \"$d\")\" set +8%; done'";
      "Mod1+z" =
        "exec ${pkgs.bash}/bin/bash -lc 'for d in /sys/class/backlight/ddcci*; do [ -e \"$d\" ] || continue; ${pkgs.brightnessctl}/bin/brightnessctl -d \"$(basename \"$d\")\" set 8%-; done'";
    };
  };
}
