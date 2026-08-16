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
  ];
}
