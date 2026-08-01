{ username, ... }:

let
  baikalFile = ../../secrets/hosts/common/baikal.yaml;
in

{
  sops.secrets."baikal/caldav_password" = {
    sopsFile = baikalFile;
    owner = username;
    group = "users";
    mode = "0400";
  };

  home-manager.users.${username}.imports = [
    ../../home/common/modules/calendar.nix
  ];
}
