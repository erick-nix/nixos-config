{ pkgs, ... }:

{
  home.packages = with pkgs; [
    video-downloader
    pwvucontrol
    switcheroo
    bazaar
    audacity
    libreoffice-qt
    papers
    refine
    upscayl
    resources
    vlc
    localsend
    cascadia-code
    adwaita-fonts
  ];
}
