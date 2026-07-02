{
  pkgs,
  lib,
  hostname ? null,
  ...
}:

let
  monitor = if hostname == "desktop" then "DP-1" else "eDP-1";

  khalWidgetScript = pkgs.writeShellScript "eww-khal-widget" ''
    cal_out="$(${pkgs.util-linux}/bin/cal)"
    khal_out="$(${pkgs.khal}/bin/khal list today 30d | ${pkgs.gnused}/bin/sed 's/\x1b\[[0-9;]*m//g')"
    ${pkgs.coreutils}/bin/printf "%s\n%s" "$cal_out" "$khal_out"
  '';
in

{
  wayland.windowManager.sway.config = {
    # start widget when launching Sway
    startup = lib.mkOptionDefault [
      {
        command = "${pkgs.bash}/bin/bash -lc '${pkgs.coreutils}/bin/sleep 1; ${pkgs.eww}/bin/eww open khal_widget'";
      }
    ];
  };

  programs.eww = {
    enable = true;
    package = pkgs.eww;
    systemd = {
      enable = true;
      target = "sway-session.target";
    };

    yuckConfig = ''
      (defpoll khal_text :interval "1h" "${khalWidgetScript}")

      (defwindow khal_widget
        :monitor "${monitor}"
        :focusable false
        :stacking "bg"
        :exclusive false
        :windowtype "dock"
        :geometry (geometry :x "18px" :y "18px" :anchor "top left")
        (box :class "khal-card" :orientation "v"
          (label :class "khal-body" :xalign 0 :yalign 0 :wrap false
                 :markup { "<span line_height='1.4'>"
                           + replace(replace(replace(khal_text, "&", "&amp;"), "<", "&lt;"), ">", "&gt;")
                           + "</span>" })))
    '';

    scssConfig = ''
      * { all: unset; font-family: "Cascadia Code"; }

      .khal-card {
        background: #161821;
        border: 1px solid #272c42;
        padding: 14px;
      }

      .khal-body {
        color: #c6c8d1;
        font-size: 14px;
      }
    '';
  };
}
