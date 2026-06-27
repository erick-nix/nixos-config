{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nautilus
    pavucontrol
    gnome-calculator
    gnome-calendar

    # Terminal
    wl-clipboard # Copy/Paste functionality.
    wooz # zoom
    imv

    # Screenshots
    grim
    slurp
    sway-contrib.grimshot
  ];
}
