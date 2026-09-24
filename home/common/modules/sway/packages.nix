{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gnome-calculator
    gnome-clocks

    # Terminal
    trash-cli
    wl-clipboard # Copy/Paste functionality.
    wooz # zoom

    # Screenshots
    grim
    slurp
    sway-contrib.grimshot
  ];

  programs = {
    yazi = {
      enable = true;
      theme = {
        indicator.padding = {
          open = "█";
          close = "█";
        };
      };
      keymap = {
        mgr.prepend_keymap = [
          {
            on = "!";
            for = "unix";
            run = ''shell "$SHELL" --block'';
            desc = "Open $SHELL here";
          }
        ];
      };
    };
  };
}
