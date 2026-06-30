{ pkgs, ... }:

{
  environment = {
    systemPackages = with pkgs; [
      ddcutil
      gnomeExtensions.brightness-control-using-ddcutil
    ];
  };

  hardware = {
    # Enable I2C for ddcutil
    i2c.enable = true;
  };
}
