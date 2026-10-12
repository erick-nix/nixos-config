{
  lib,
  pkgs,
  username,
  hostname,
  ...
}:

{
  services = {
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd sway";
          user = "greeter";
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

  xdg.portal = {
    enable = true;
    config.common.default = "gtk";
    wlr.enable = true;

    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  systemd.user.services.xdg-desktop-portal-wlr = {
    path = [
      pkgs.fuzzel
    ];
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
