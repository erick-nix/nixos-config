{ pkgs, ... }:

{
  home.packages = with pkgs; [
    wl-clipboard # Copy/Paste functionality.
    wooz # zoom
    nautilus
    pavucontrol
    gnome-calculator
    gnome-calendar

    # Screenshots
    grim
    slurp
    sway-contrib.grimshot
  ];
}
