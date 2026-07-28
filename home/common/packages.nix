{ pkgs, ... }:

{
  home.packages = with pkgs; [
    video-downloader
    pwvucontrol
    switcheroo
    audacity
    libreoffice-qt
    papers
    refine
    upscayl
    resources
    vlc
    handbrake
    cascadia-code
    adwaita-fonts
  ];
}
