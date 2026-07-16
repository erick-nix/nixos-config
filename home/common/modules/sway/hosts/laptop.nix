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
      "XF86AudioRaiseVolume" = "exec ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
      "XF86AudioLowerVolume" = "exec ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
      "XF86AudioMute" = "exec ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
      "XF86MonBrightnessUp" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 5%+";
      "XF86MonBrightnessDown" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 5%-";
    };
  };

  programs.waybar.settings.mainBar = {
    modules-right = lib.mkForce [
      "network"
      "custom/cpu_temp"
      "disk#root"
      "memory"
      "cpu"
      "pulseaudio"
      "backlight"
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
