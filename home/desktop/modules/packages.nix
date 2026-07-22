{
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    gimp
    inkscape
    tor-browser
    proton-vpn
    discord
    pear-desktop
    chromium
    qbittorrent
  ];
}
