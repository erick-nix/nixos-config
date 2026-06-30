{ pkgs, ... }:

{
  home.packages = with pkgs; [
    thunar
    pavucontrol
    gnome-calculator
    gnome-calendar
    gnome-clocks

    # Terminal
    wl-clipboard # Copy/Paste functionality.
    wooz # zoom

    # Screenshots
    grim
    slurp
    sway-contrib.grimshot
  ];
}
