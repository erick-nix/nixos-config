{
  lib,
  pkgs,
  hostname ? null,
  ...
}:

lib.mkIf (hostname == "laptop") {
  wayland.windowManager.sway.config = {
    seat = {
      "*" = {
        xcursor_theme = "Adwaita 22";
      };
    };

    input = {
      "*" = {
        xkb_model = lib.mkForce "thinkpad60";
        xkb_layout = lib.mkForce "br";
        xkb_variant = lib.mkForce "abnt2";
      };

      "type:touchpad" = {
        tap = "enabled";
        natural_scroll = "enabled";
        pointer_accel = "0.35";
      };
    };

    output = {
      "eDP-1" = {
        scale = "1.25";
      };
    };

    keybindings = lib.mkOptionDefault {
      # Laptop panel brightness via Fn keys (F6/F5)
      "XF86MonBrightnessUp" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set +10%";
      "XF86MonBrightnessDown" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 10%-";
      "XF86AudioMicMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle";
    };
  };
}
