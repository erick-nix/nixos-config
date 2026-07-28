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
    chromium
    qbittorrent
    pear-desktop
  ];
}
