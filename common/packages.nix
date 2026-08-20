{ pkgs, ... }:

{
  environment = {
    # Define system-wide packages to be installed
    systemPackages = with pkgs; [
      gparted
      kdiskmark
      qdiskinfo
      lm_sensors

      # Nix
      nixfmt
      sops

      # Terminal
      stress
    ];
  };
}
