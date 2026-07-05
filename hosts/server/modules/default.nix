{ ... }:

{
  imports = [
    ./networking.nix
    ./services.nix
    ./programs.nix
    ./system.nix
    ./systemd.nix
    ./server
  ];
}
