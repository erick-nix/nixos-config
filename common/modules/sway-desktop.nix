{
  lib,
  pkgs,
  username,
  hostname,
  ...
}:

let
  baikalFile = ../../secrets/hosts/common/baikal.yaml;
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

      ly = {
        enable = true;
        x11Support = false;
        settings = {
          session_log = "";
          allow_empty_password = false;
          bigclock = "en";
          bg = lib.fromHexString "0x00161821";
        };
      };
    };

    # Bluetooth
    blueman.enable = true;

    gvfs.enable = true; # Mount, trash, and other functionalities
    udisks2.enable = true; # Backend for mounting disks from file managers
    tumbler.enable = true; # Thumbnail support for images

    # Enables Gnome Keyring to store secrets for applications.
    gnome.gnome-keyring.enable = true;
  };

  # Screen sharing
  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };
}
