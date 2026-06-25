{
  pkgs,
  lib,
  ...
}:

let
  scripts = import ./scripts.nix { inherit pkgs; };
in

{
  home.packages = [
    scripts.btMenu
  ];

  wayland.windowManager.sway.config = {
    keybindings = lib.mkOptionDefault ({
      "Mod4+Return" = "exec ghostty";
      "Mod4+b" = "exec ${scripts.btMenu}/bin/bt-menu";
      "Mod3+w" = "exec wooz --invert-scroll";

      # Volume
      "XF86AudioRaiseVolume" = "exec ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
      "XF86AudioLowerVolume" = "exec ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
      "XF86AudioMute" = "exec ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";

      # Turn focused tab into floating bottom half window.
      "Mod4+Shift+Down" = "floating enable, resize set 100 ppt 50 ppt, move position 0 ppt 50 ppt";

      # Clipboard history
      "Mod4+v" =
        "exec ${pkgs.bash}/bin/bash -lc '${pkgs.cliphist}/bin/cliphist list | ${pkgs.fuzzel}/bin/fuzzel --dmenu --with-nth 2 --prompt \"Clipboard: \" | ${pkgs.cliphist}/bin/cliphist decode | ${pkgs.wl-clipboard}/bin/wl-copy'";
      "Mod4+Shift+BackSpace" = "exec ${pkgs.cliphist}/bin/cliphist wipe";

      # Screenshots
      "Print" =
        "exec selection=$(slurp) && grim -g \"$selection\" - | tee ~/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png | wl-copy";
    });

    # Set apps to open in windowed mode.
    window.commands = [
      {
        criteria = {
          app_id = "blueman-manager";
        };
        command = "floating enable, resize set 900 600, move position center";
      }
    ];
  };
}
