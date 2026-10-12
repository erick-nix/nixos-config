{ pkgs, ... }:

{
  home.packages = with pkgs; [
    thunar
    gnome-calculator
    gnome-clocks

    # Terminal
    trash-cli
    wl-clipboard
    wooz # zoom

    # Screenshots
    grim
    slurp
    sway-contrib.grimshot
  ];
}
