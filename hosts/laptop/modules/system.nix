# Core system settings: bootloader, kernel, locale, user, nix options

{ ... }:

{
  hardware = {
    # Disable Bluetooth at boot
    bluetooth = {
      powerOnBoot = false;
    };
  };

  boot = {
    # Load amdgpu in initrd so it takes over the framebuffer before vconsole-setup runs, otherwise it resets the console font to default
    # https://github.com/NixOS/nixpkgs/issues/219239
    initrd.kernelModules = [ "amdgpu" ];
  };

  console = {
    font = "Tamsyn10x20r";
  };

  swapDevices = [
    { device = "/swap/swapfile"; }
  ];

  system = {
    # DO NOT change this after install — keeps compatibility with old data
    stateVersion = "26.05";
  };
}
