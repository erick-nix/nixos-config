{ pkgs, username, ... }:

{
  hardware.i2c.enable = true;

  environment.systemPackages = with pkgs; [
    ddcutil
  ];

  users.users.${username}.extraGroups = [ "i2c" ];
}
