{ pkgs, ... }:

{
  environment = {
    # Define system-wide packages to be installed
    systemPackages = with pkgs; [
      hdparm
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
