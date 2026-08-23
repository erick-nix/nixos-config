{
  lib,
  pkgs,
  hostname ? null,
  ...
}:

let
  scripts = import ../scripts.nix { inherit pkgs; };
in

lib.mkIf (hostname == "desktop") {
  home.packages = [
    scripts.ddcBrightness
  ];

  wayland.windowManager.sway.config = {
    output."*".background = "${../../../../desktop/assets/wallpaper.webp} fill";

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
      # KDE Connect
      {
        command = "${pkgs.kdePackages.kdeconnect-kde}/bin/kdeconnect-indicator";
      }
    ];

    keybindings = lib.mkOptionDefault {
      "Mod1+x" = "exec exec ${scripts.ddcBrightness}/bin/ddc-brightness up 8";
      "Mod1+z" = "exec exec ${scripts.ddcBrightness}/bin/ddc-brightness down 8";
    };
  };

  programs.waybar.settings.mainBar = {
    modules-right = [
      "custom/network"
      "disk#root"
      "custom/brightness"
      "pulseaudio"
      "memory"
      "cpu"
      "custom/cpu_temp"
      "clock"
      "tray"
    ];

    "custom/brightness" = {
      interval = 1;
      format = "BRI {}%";
      justify = "center";
      exec = ''${pkgs.bash}/bin/bash -lc "cat ''${XDG_CACHE_HOME:-$HOME/.cache}/ddc-brightness/target 2>/dev/null || echo 50"'';
    };
  };
}
