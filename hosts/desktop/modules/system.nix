# Core system settings: bootloader, kernel, locale, user, nix options

{
  config,
  ...
}:

{
  powerManagement.cpuFreqGovernor = "performance";

  # Create new backlight devices, kernel > 6.8
  # echo "ddcci 0x37" | sudo tee /sys/bus/i2c/devices/i2c-6/new_device
  boot.extraModulePackages = [ config.boot.kernelPackages.ddcci-driver ];
  boot.kernelModules = [
    "ddcci"
    "ddcci_backlight"
  ];

  # Swap
  swapDevices = [
    { device = "/swap/swapfile"; }
  ];

  hardware = {
    amdgpu.overdrive.enable = true;

    # Used for scanning with the printer
    sane = {
      enable = true;
      brscan4 = {
        enable = true;
        netDevices = {
          home = {
            model = "DCP-1610NW";
            ip = "192.168.1.3";
          };
        };
      };
    };

    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  system = {
    autoUpgrade = {
      enable = true;
      dates = "weekly";
      operation = "boot";

      flake = "/etc/nixos";
      flags = [
        "--update-input"
        "nixpkgs"
      ];
    };

    # DO NOT change this after install — keeps compatibility with old data
    stateVersion = "25.05";
  };
}
