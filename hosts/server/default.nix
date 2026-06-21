{ inputs, ... }:

let
  username = "erick-nix";
  homeDir = "/home/${username}";
  domain = "erick-nix.com";
in

{
  flake.nixosConfigurations.server = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";

    specialArgs = {
      inherit
        inputs
        domain
        username
        homeDir
        ;
    };

    modules = [
      ../../common
      ../../common/modules/gnome-desktop.nix
      ../../common/modules/ddcutil.nix
      ./configuration.nix
    ];
  };
}
