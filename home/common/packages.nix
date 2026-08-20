{ pkgs, ... }:

{
  home.packages = with pkgs; [
    video-downloader
    pwvucontrol
    switcheroo
    audacity
    onlyoffice-desktopeditors
    papers
    refine
    upscayl
    resources
    vlc
    handbrake
    cascadia-code
    adwaita-fonts

    # Nix
    nh
    nix-output-monitor

    # Terminal
    s-tui
    ncdu
    vim
    fastfetch
    tree
    btop
    nmap
    wget
    imv
    openssl
    ouch-rar
  ];
}
