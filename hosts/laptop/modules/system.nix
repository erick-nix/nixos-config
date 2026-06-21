# Core system settings: bootloader, kernel, locale, user, nix options

{ ... }:

{
  hardware = {
    # Disable Bluetooth at boot
    bluetooth = {
      powerOnBoot = false;
    };
  };

  system = {
    # DO NOT change this after install — keeps compatibility with old data
    stateVersion = "25.05";
  };
}
