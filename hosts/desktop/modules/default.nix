{ ... }:

{
  imports = [
    ./filesystems.nix
    ./networking.nix
    ./programs.nix
    ./services.nix
    ./system.nix
    ./backlight.nix.nix
    #./vfio.nix
  ];
}
