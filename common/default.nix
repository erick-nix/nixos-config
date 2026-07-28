{
  config,
  inputs,
  pkgs,
  ...
}:

let
  pkgsUnstable = import inputs.nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;
    config = config.nixpkgs.config;
  };
in
{
  _module.args.hostname = config.networking.hostName;
  _module.args.pkgsUnstable = pkgsUnstable;

  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops
    inputs.nvf.nixosModules.default
    inputs.nix-index-database.nixosModules.default

    ./networking.nix
    ./packages.nix
    ./programs.nix
    ./services.nix
    ./system.nix
    ./systemd.nix
    ./nvim
    ./modules/syncthing.nix
    ./modules/tailscale.nix
    ./modules/gaming.nix
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = { inherit inputs pkgsUnstable; };
  home-manager.backupFileExtension = "hm-backup";
}
