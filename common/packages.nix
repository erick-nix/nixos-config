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
      nix-output-monitor
      nh
      nixfmt
      sops

      # Terminal
      s-tui
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
      ouch-rar
    ];

    # TODO: remove in the future
    # https://github.com/NixOS/nixpkgs/issues/546204
    sessionVariables.XDG_DATA_DIRS = [
      "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}"
      "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}"
    ];
  };
}
