{ pkgs, ... }:

{
  home.packages = with pkgs; [
    video-downloader
    pwvucontrol
    switcheroo
    bazaar
    gimp-with-plugins
    audacity
    libreoffice-qt
    papers
    refine
    upscayl
    resources
    vlc
    localsend
    libertine
    cascadia-code
    adwaita-fonts
    yt-dlp
  ];
}
