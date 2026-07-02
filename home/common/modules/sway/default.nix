{
  lib,
  pkgs,
  ...
}:

{
  wayland.systemd.target = "sway-session.target";

  imports = [
    ./calendar.nix
    ./services.nix
    ./ui.nix
    ./keybindings.nix
    ./packages.nix
    ./xdg.nix
    ./hosts/desktop.nix
    ./hosts/laptop.nix
  ];

  wayland.windowManager.sway = {
    enable = true;

    config = {
      modifier = "Mod4";
      terminal = "ghostty";
      menu = "${pkgs.fuzzel}/bin/fuzzel";
      workspaceLayout = "tabbed";
      focus.followMouse = "no";

      # Clipboard
      startup = lib.mkOptionDefault [
        {
          # Polkit authentication prompts for pkexec/GVFS actions in Sway sessions.
          command = "${pkgs.lxqt.lxqt-policykit}/bin/lxqt-policykit-agent";
        }
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
