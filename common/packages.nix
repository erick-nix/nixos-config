{ pkgs, ... }:

{
  # Define system-wide packages to be installed
  environment = {
    systemPackages = with pkgs; [
      gparted
      kdiskmark
      qdiskinfo
      lm_sensors

      # Nix
      nix-output-monitor
      nh
      nix-index
      nixfmt

      # Terminal
      s-tui
      sc-im
      git
      ncdu
      iw
      vim
      fastfetch
      tree
      btop
      stress
      nmap
      sops
      wget
      imv
      yt-dlp
    ];
  };
}
