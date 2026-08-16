# System services: graphical interface, printing, sound, networking, Docker, Snapper, etc.

{
  pkgs,
  ...
}:

{
  services = {
    xserver = {
      xkb = {
        layout = "br";
        variant = "abnt2";
      };
    };

    openssh = {
      enable = true;

      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PubkeyAuthentication = true;
        PermitRootLogin = "no";
      };
    };

    # To update the BIOS and other things
    fwupd.enable = true;

    # Low battery notifications
    upower = {
      enable = true;
      percentageLow = 20;
    };

    flatpak = {
      enable = true;
    };

    printing = {
      enable = true;
      drivers = with pkgs; [
        cups-brother-dcp1610wlpr
        cups-filters
      ];
    };

    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;

      extraConfig.pipewire."92-low-latency" = {
        "context.properties" = {
          "default.clock.rate" = 48000;
          "default.clock.quantum" = 256;
          "default.clock.min-quantum" = 128;
          "default.clock.max-quantum" = 512;
        };
      };
    };

    avahi = {
      enable = true;
      nssmdns4 = false;
      publish = {
        enable = true;
        addresses = true;
        userServices = true;
      };
      openFirewall = true;
    };

    # Used systemd-resolved to avoid DNS conflicts, especially with VPNs
    resolved = {
      enable = true;
      settings.Resolve.DNSSEC = "false";
    };
  };
}
