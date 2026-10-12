{ username, ... }:

{
  programs = {
    dconf.enable = true;
  };

  home-manager.users.${username}.imports = [
    ../../home/common/modules/themes.nix
  ];
}
