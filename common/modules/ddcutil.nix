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

  boot = {
    kernelModules = [
      "i2c-dev"
    ];
  };

  services = {
    udev.extraRules = ''
      KERNEL=="i2c-[0-9]*", TAG+="uaccess"
    '';
  };
}
