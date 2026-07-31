{
  config,
  lib,
  pkgs,
  username,
  hostname,
  ...
}:

let
  baikalFile = ../../secrets/hosts/common/baikal.yaml;

  hmSessionVars = config.home-manager.users.${username}.home.sessionVariables;
  hmSearchVars = config.home-manager.users.${username}.home.sessionSearchVariables;
in

{
  sops.secrets."baikal/caldav_password" = {
    sopsFile = baikalFile;
    owner = "erick-nix";
    group = "users";
    mode = "0400";
  };

  programs = {
    sway = {
      enable = true;
      wrapperFeatures.gtk = true;

      # Override default extras to avoid pulling in Foot.
      extraPackages = with pkgs; [
        swayidle
        swaylock
        wmenu
      ];
    };

    thunar = {
      enable = true;
      plugins = with pkgs; [
        thunar-archive-plugin
      ];
    };
  };

  home-manager.users.${username}.imports = [
    (
      { ... }:
      {
        _module.args.hostname = hostname;
        imports = [ ../../home/common/modules/sway ];
      }
    )
  ];

  services = {
    displayManager = {
      defaultSession = "sway";
    };

    greetd = {
      enable = true;
      useTextGreeter = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd sway";
          user = "greeter";
        };
      };
    };

    logind.settings.Login = lib.mkIf (hostname == "laptop") {
      HandleLidSwitch = "suspend";
      HandleLidSwitchExternalPower = "suspend";
    };

    # Bluetooth
    blueman.enable = true;

    gvfs.enable = true; # Mount, trash, and other functionalities
    udisks2.enable = true; # Backend for mounting disks from file managers
    tumbler.enable = true; # Thumbnail support for images

    # Enables Gnome Keyring to store secrets for applications.
    gnome.gnome-keyring.enable = true;
  };

  security.pam.services.swaylock = { };

  # Screen sharing
  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };

  # Session variables (e.g. Qt theming) never reach sway unless re-exported here.
  environment.sessionVariables = {
    EDITOR = hmSessionVars.EDITOR;
    QT_QPA_PLATFORMTHEME = hmSessionVars.QT_QPA_PLATFORMTHEME;
    QT_STYLE_OVERRIDE = hmSessionVars.QT_STYLE_OVERRIDE;
    QT_PLUGIN_PATH = lib.concatStringsSep ":" hmSearchVars.QT_PLUGIN_PATH;
    QML2_IMPORT_PATH = lib.concatStringsSep ":" hmSearchVars.QML2_IMPORT_PATH;
  };
}
