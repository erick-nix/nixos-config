{ config, ... }:

{
  _module.args.homeDir = config.home.homeDirectory;

  imports = [
    ./packages.nix
    ./programs.nix
    ./modules/gtk.nix
    ./modules/qt.nix
  ];

  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";

    EDITOR = "nvim";
    NIXOS_OZONE_WL = 1;
  };

  programs.home-manager.enable = true;
  services.home-manager.autoExpire = {
    enable = true;
    frequency = "daily";
    timestamp = "-7 days";
    # Keep generation cleanup, but avoid per-user store GC.
    # Store GC is already handled at system level in common/system.nix.
    store.cleanup = false;
  };
}
