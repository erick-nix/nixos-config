{ inputs, ... }:

let
  username = "erick-nix";
  homeDir = "/home/${username}";
in

{
  flake.nixosConfigurations.laptop = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";

    specialArgs = { inherit inputs username homeDir; };

    modules = [
      ../../common
      ../../common/modules/gnome-desktop.nix
      ../../common/modules/systemd-cleanup.nix
      ../../common/modules/obs.nix
      ../../common/modules/work.nix
      ./configuration.nix
    ];
  };
}
