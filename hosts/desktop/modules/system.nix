# Core system settings: bootloader, kernel, locale, user, nix options

{
  ...
}:

{
  powerManagement.cpuFreqGovernor = "performance";

  # Swap
  swapDevices = [
    { device = "/swap/swapfile"; }
  ];

  boot = {
    # Load amdgpu in initrd so it takes over the framebuffer before vconsole-setup runs, otherwise it resets the console font to default
    # https://github.com/NixOS/nixpkgs/issues/219239
    initrd.kernelModules = [ "amdgpu" ];
  };

  console = {
    font = "Tamsyn8x16r";
  };

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
