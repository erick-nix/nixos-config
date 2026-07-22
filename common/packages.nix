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
      nixfmt
      sops

      # Terminal
      s-tui
      git
      ncdu
      iw
      vim
      fastfetch
      tree
      btop
      stress
      nmap
      wget
      imv
      yt-dlp
      openssl
    ];
  };
}
