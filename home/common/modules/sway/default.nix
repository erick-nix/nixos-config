{
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./services.nix
    ./ui.nix
    ./keybindings.nix
    ./packages.nix
    ./xdg.nix
    ./modules/desktop.nix
    ./modules/laptop.nix
  ];

  wayland.windowManager.sway = {
    enable = true;

    config = {
      modifier = "Mod4";
      terminal = "ghostty";
      menu = "${pkgs.fuzzel}/bin/fuzzel";
      workspaceLayout = "tabbed";

      # Clipboard
      startup = lib.mkOptionDefault [
        {
          command = "${pkgs.wl-clipboard}/bin/wl-paste --type text --watch ${pkgs.cliphist}/bin/cliphist store";
        }
        {
          command = "${pkgs.wl-clipboard}/bin/wl-paste --type image --watch ${pkgs.cliphist}/bin/cliphist store";
        }
      ];

      input = {
        "*" = {
          xkb_layout = "br";
          xkb_variant = "abnt2";
        };
      };
    };
  };
}
