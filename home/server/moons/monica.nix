{ pkgs, ... }:

{
  home = {
    sessionVariables = {
      LANG = "pt_BR.UTF-8";
      LC_TIME = "pt_BR.UTF-8";
      LC_MEASUREMENT = "pt_BR.UTF-8";
      LC_PAPER = "pt_BR.UTF-8";
      LC_NUMERIC = "pt_BR.UTF-8";
      LC_MONETARY = "pt_BR.UTF-8";

      EDITOR = "nano";
      NIXOS_OZONE_WL = 1;
    };

    username = "monica";
    homeDirectory = "/home/monica";
    stateVersion = "25.11";

    packages = with pkgs; [
      onlyoffice-desktopeditors
      video-downloader
      switcheroo
      bazaar
      localsend
      google-chrome
      papers
      refine
      resources
    ];
  };

  dconf.settings = {
    "system/locale" = {
      region = "pt_BR.UTF-8";
    };
  };

  programs = {
    home-manager.enable = true;
  };
}
