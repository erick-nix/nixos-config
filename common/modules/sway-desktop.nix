{ pkgs, username, ... }:

{
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  home-manager.users.${username}.imports = [
    ../../home/common/modules/sway
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

    # Enables Gnome Keyring to store secrets for applications.
    gnome.gnome-keyring.enable = true;
  };
}
