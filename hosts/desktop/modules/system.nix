# Core system settings: bootloader, kernel, locale, user, nix options

{
  pkgsUnstable,
  ...
}:

{
  powerManagement.cpuFreqGovernor = "performance";

  # Swap
  swapDevices = [
    { device = "/swap/swapfile"; }
  ];

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware = {
    nvidia = {
      open = true;
      modesetting.enable = true;
      powerManagement.enable = false;
      package = pkgsUnstable.linuxPackages_latest.nvidiaPackages.latest;
    };

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

  nix.settings = {
    # CUDA
    substituters = [ "https://cache.nixos-cuda.org" ];
    trusted-public-keys = [ "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M=" ];
  };

  boot.kernelPackages = pkgsUnstable.linuxPackages_latest;

  system = {
    autoUpgrade = {
      enable = true;
      dates = "weekly";
      operation = "boot";

      flake = "/etc/nixos";
      flags = [
        "--recreate-lock-file"
        "--commit-lock-file"
      ];
    };

    # DO NOT change this after install — keeps compatibility with old data
    stateVersion = "25.05";
  };
}
