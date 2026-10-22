{
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    # battery
    tlp

    gimp
    inkscape
    pear-desktop
    qbittorrent
  ];
}
