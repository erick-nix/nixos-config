{ pkgs, ... }:

{
  environment = {
    # Define system-wide packages to be installed
    systemPackages = with pkgs; [
      hdparm
      gparted
      lm_sensors

      # Nix
      nixfmt
      sops

      # Terminal
      stress
    ];
  };
}
