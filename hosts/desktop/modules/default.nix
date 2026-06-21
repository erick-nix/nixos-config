{ ... }:

{
  imports = [
    ./filesystems.nix
    ./networking.nix
    ./programs.nix
    ./services.nix
    ./system.nix
    ./text-extractor.nix
    #./vfio.nix
  ];
}
