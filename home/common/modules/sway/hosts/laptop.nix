{
  pkgs,
  lib,
  hostname ? null,
  ...
}:

lib.mkIf (hostname == "laptop") {
  wayland.windowManager.sway.config = {
    workspaceOutputAssign = [
      {
        workspace = "1";
        output = "eDP-1";
      }
    ];

    output = {
      "eDP-1" = {
        scale = "1.25";
      };
    };

    seat = {
      "*" = {
        xcursor_theme = "Adwaita 22";
      };
    };

    input = {
      "*" = {
        xkb_model = lib.mkForce "thinkpad60";
        xkb_layout = lib.mkForce "br";
      };

      "type:touchpad" = {
        tap = "enabled";
        natural_scroll = "enabled";
        pointer_accel = "0.35";
      };
    };

    keybindings = lib.mkOptionDefault {
      "Mod1+x" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 5%+";
      "Mod1+z" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 5%-";
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
      "battery"
      "clock"
      "tray"
    ];

    battery = {
      interval = 10;
      states = {
        warning = 30;
        critical = 15;
      };
      format = "BAT {capacity}%";
      "format-charging" = "BAT +{capacity}%";
      "format-plugged" = "BAT AC";
      "format-full" = "BAT FULL";
      "tooltip-format" = "{timeTo}";
    };
  };
}
