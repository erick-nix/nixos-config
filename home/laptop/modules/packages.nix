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
    discord
    pear-desktop
    qbittorrent
  ];
}
