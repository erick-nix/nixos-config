{
  lib,
  pkgs,
  hostname ? null,
  ...
}:

{
  imports = [
    ./services.nix
    ./ui.nix
    ./keybindings.nix
    ./packages.nix
  ];

  wayland.windowManager.sway = {
    enable = true;

    config = lib.mkMerge [
      {
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
      }

      # Config in desktop
      (lib.mkIf (hostname == "desktop") {
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
      })
    ];
  };
}
