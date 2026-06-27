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

    keybindings = lib.mkOptionDefault {
      # Desktop external monitor brightness via ddcutil
      "Mod4+period" = "exec ${scripts.ddcBrightness}/bin/ddc-brightness up 8";
      "Mod4+comma" = "exec ${scripts.ddcBrightness}/bin/ddc-brightness down 8";
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
