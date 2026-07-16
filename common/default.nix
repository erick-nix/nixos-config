{
  config,
  inputs,
  pkgs,
  ...
}:

{
  _module.args.hostname = config.networking.hostName;
  _module.args.pkgsUnstable = import inputs.nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;
    config = config.nixpkgs.config;
  };

  imports = [
    inputs.sops-nix.nixosModules.sops
    inputs.home-manager.nixosModules.home-manager
    inputs.nvf.nixosModules.default

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
  home-manager.extraSpecialArgs = { inherit inputs; };
  home-manager.backupFileExtension = "hm-backup";
}
