{
  lib,
  pkgs,
  hostname ? null,
  ...
}:

let
  scripts = import ../scripts.nix { inherit pkgs; };
  khalWidgetScript = pkgs.writeShellScript "eww-khal-widget" ''
    ${pkgs.khal}/bin/khal calendar | ${pkgs.gnused}/bin/sed 's/\x1b\[[0-9;]*m//g'
  '';
in

lib.mkIf (hostname == "desktop") {
  home.packages = [
    scripts.ddcBrightness
  ];

  programs.eww = {
    enable = true;
    package = pkgs.eww;
    systemd = {
      enable = true;
      target = "sway-session.target";
    };
    yuckConfig = ''
      (defpoll khal_text :interval "60s" "${khalWidgetScript}")

      (defwindow khal_widget
        :monitor "DP-2"
        :focusable false
        :stacking "bg"
        :exclusive false
        :windowtype "dock"
        :geometry (geometry :x "18px" :y "18px" :width "460px" :height "760px" :anchor "top left")
        (box :class "khal-card" :orientation "v"
          (label :class "khal-title" :xalign 0 :text "Agenda")
          (label :class "khal-body" :xalign 0 :yalign 0 :wrap true :text khal_text)))
    '';
    scssConfig = ''
      * {
        all: unset;
        font-family: "Cascadia Code";
      }

      .khal-card {
        background: rgba(22, 24, 33, 0.72);
        border: 1px solid rgba(111, 136, 183, 0.75);
        border-radius: 10px;
        padding: 14px;
        min-height: 760px;
      }

      .khal-title {
        color: #91acd1;
        font-size: 16px;
        font-weight: 700;
        margin-bottom: 10px;
      }

      .khal-body {
        color: #c6c8d1;
        font-size: 12px;
      }
    '';
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

    startup = lib.mkOptionDefault [
      {
        command = "${pkgs.bash}/bin/bash -lc '${pkgs.coreutils}/bin/sleep 1; ${pkgs.eww}/bin/eww open khal_widget'";
      }
    ];

    keybindings = lib.mkOptionDefault {
      # Desktop external monitor brightness via ddcutil
      "Mod4+period" = "exec ${scripts.ddcBrightness}/bin/ddc-brightness up 8";
      "Mod4+comma" = "exec ${scripts.ddcBrightness}/bin/ddc-brightness down 8";
      "Mod4+Shift+k" = "exec ${pkgs.eww}/bin/eww open --toggle khal_widget";
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
      "custom/brightness"
      "clock"
      "tray"
    ];

    network = {
      "interface" = "enp9s0";
    };

    "custom/brightness" = {
      interval = 1;
      format = "BRI {}%";
      justify = "center";
      exec = ''${pkgs.bash}/bin/bash -lc "cat ''${XDG_CACHE_HOME:-$HOME/.cache}/ddc-brightness/target 2>/dev/null || echo 50"'';
    };
  };
}
