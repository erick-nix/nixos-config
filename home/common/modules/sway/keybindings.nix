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
      "Mod4+e" = "exec thunar";

      # Volume
      "Mod4+x" = "exec ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
      "Mod4+z" = "exec ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
      "Mod4+c" = "exec ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";

      # Zoom
      "Mod1+w" = "exec wooz --invert-scroll";
      "Mod3+w" = "exec wooz --invert-scroll";

      # Turn focused tab into floating bottom half window.
      "Mod4+Shift+Down" = "floating enable, resize set 100 ppt 50 ppt, move position 0 ppt 50 ppt";

      # Override default floating toggle to also set a standard floating size.
      "Mod4+Shift+space" = lib.mkForce "floating toggle, resize set 1100 px 700 px, move position center";

      # Clipboard history
      "Mod4+v" =
        "exec ${pkgs.bash}/bin/bash -lc '${pkgs.cliphist}/bin/cliphist list | ${pkgs.fuzzel}/bin/fuzzel --dmenu --with-nth 2 --prompt \"Clipboard: \" | ${pkgs.cliphist}/bin/cliphist decode | ${pkgs.wl-clipboard}/bin/wl-copy'";
      "Mod4+Shift+BackSpace" = "exec ${pkgs.cliphist}/bin/cliphist wipe";

      # Screenshots
      "Print" =
        "exec selection=$(slurp) && grim -g \"$selection\" - | tee ~/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png | wl-copy";
    });
  };
}
