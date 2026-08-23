{
  config,
  lib,
  pkgs,
  username,
  hostname,
  ...
}:

let
  hmSessionVars = config.home-manager.users.${username}.home.sessionVariables;
  hmSearchVars = config.home-manager.users.${username}.home.sessionSearchVariables;
in

{
  programs = {
    sway = {
      enable = true;
      wrapperFeatures.gtk = true;

      # Override default extras to avoid pulling in Foot.
      extraPackages = with pkgs; [
        swayidle
        swaylock-effects
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

  services = {
    displayManager = {
      defaultSession = "sway";

      ly = {
        enable = true;
        x11Support = false;
        settings = {
          session_log = "";
          allow_empty_password = false;
        };
      };
    };

    # Low battery notifications (used for poweralertd)
    upower = {
      enable = true;
      percentageLow = 20;
    };

    # Mount, trash, and other functionalities
    gvfs.enable = true;

    # Backend for mounting disks from file managers
    udisks2.enable = true;

    # Thumbnail support for images
    tumbler.enable = true;

    # Enables Gnome Keyring to store secrets for applications.
    gnome.gnome-keyring.enable = true;

    # Suspend on laptop lid close
    logind.settings.Login = lib.mkIf (hostname == "laptop") {
      HandleLidSwitch = "suspend";
      HandleLidSwitchExternalPower = "suspend";
    };
  };

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

  # Import sway module from home-manager
  home-manager.users.${username}.imports = [
    (
      { ... }:
      {
        _module.args.hostname = hostname;
        imports = [ ../../home/common/modules/sway ];
      }
    )
  ];
}
