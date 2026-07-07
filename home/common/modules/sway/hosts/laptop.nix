{
  lib,
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
  };

  # services.wluma = {
  #   enable = false;
  #   settings = {
  #     als.time.thresholds = {
  #       "0" = "night";
  #       "8" = "day";
  #       "18" = "night";
  #     };
  #
  #     output.backlight = [
  #       {
  #         name = "DP-2";
  #         path = "/sys/class/backlight/ddcci6";
  #         capturer = "wayland";
  #         predictor.manual.thresholds.day = {
  #           "0" = 0;
  #           "40" = 5;
  #           "60" = 10;
  #           "75" = 18;
  #         };
  #         predictor.manual.thresholds.night = {
  #           "0" = 0;
  #           "40" = 17;
  #           "60" = 31;
  #           "75" = 50;
  #         };
  #       }
  #     ];
  #   };
  # };
}
