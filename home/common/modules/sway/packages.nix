{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gnome-calculator
    gnome-clocks
    converseen

    # Terminal
    wl-clipboard # Copy/Paste functionality.
    wooz # zoom

    # Screenshots
    grim
    slurp
    sway-contrib.grimshot
  ];
}
