{
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    tor-browser
    clang-tools
    proton-vpn
    discord
    qbittorrent
  ];
}
