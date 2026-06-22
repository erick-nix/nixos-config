{
  pkgs,
  username,
  hostname,
  ...
}:

{
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;

    # Override default extras to avoid pulling in Foot.
    extraPackages = with pkgs; [
      swayidle
      swaylock
      wmenu
    ];
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
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd sway";
          user = "greeter";
        };
      };
    };

    # Required for GNOME Calendar background services in non-GNOME sessions.
    gnome.evolution-data-server.enable = true;
    gnome.gnome-online-accounts.enable = true;

    # Enables Gnome Keyring to store secrets for applications.
    gnome.gnome-keyring.enable = true;
  };

  # Screen sharing
  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };
}
