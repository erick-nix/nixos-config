{
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    video-downloader
    pwvucontrol
    switcheroo
    bazaar
    gimp-with-plugins
    libreoffice-qt
    papers
    refine
    resources
    vlc
    localsend
    google-chrome
    libertine
    cascadia-code
    adwaita-fonts
    upscayl
  ];
}
