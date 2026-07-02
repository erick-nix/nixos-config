{
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    gimp
    inkscape
    gnome-power-manager
    discord
    qbittorrent
  ];
}
