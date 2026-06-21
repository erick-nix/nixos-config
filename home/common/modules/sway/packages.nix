{ pkgs, ... }:

{
  home.packages = with pkgs; [
    wl-clipboard # Copy/Paste functionality.
    nautilus
    pavucontrol
    gnome-calculator
  ];
}
