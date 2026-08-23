# Core system settings: bootloader, kernel, locale, user, nix options

{ pkgs, ... }:

{
  hardware = {
    # Disable Bluetooth at boot
    bluetooth = {
      powerOnBoot = false;
    };
  };

  boot = {
    # Load amdgpu in initrd so it takes over the framebuffer before vconsole-setup runs, otherwise it resets the console font to default
    # can only be applied to laptops because it messes up ddc entries
    # https://github.com/NixOS/nixpkgs/issues/219239
    initrd.kernelModules = [ "amdgpu" ];
  };

  console = {
    font = "ter-v22n";
    packages = with pkgs; [
      terminus_font
    ];
  };

  swapDevices = [
    { device = "/swap/swapfile"; }
  ];

  system = {
    # DO NOT change this after install — keeps compatibility with old data
    stateVersion = "26.05";
  };
}
