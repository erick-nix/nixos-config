{ pkgs, ... }:

{
  hardware = {
    # Enable I2C for ddcutil
    i2c.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [
      ddcutil
      pkgs.ddcutil-service
      gnomeExtensions.brightness-control-using-ddcutil
    ];
  };
}
