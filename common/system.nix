# Core system settings: bootloader, kernel, locale, user, nix options

{ pkgs, ... }:

{
  # Secrets
  sops.age.keyFile = "/root/.config/sops/age/keys.txt";

  # Timezone
  time.timeZone = "America/Sao_Paulo";

  # Set ZSH as default shell
  users.defaultUserShell = pkgs.zsh;

  # Enable polkit
  security.polkit.enable = true;

  # Set the system default locale
  i18n = {
    defaultLocale = "en_US.UTF-8";

    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "pt_BR.UTF-8/UTF-8"
    ];

    inputMethod = {
      enable = true;
      type = "ibus";
    };
  };

  # Fonts
  fonts = {
    fontconfig = {
      enable = true;
      defaultFonts = {
        sansSerif = [ "Adwaita Sans" ];
        serif = [ "Adwaita Serif" ];
        monospace = [ "Cascadia Code" ];
      };
    };
  };

  # Bootloader, kernel modules, and filesystem support
  boot = {
    # Bootloader configuration, enable GRUB
    loader = {
      systemd-boot.enable = false;
      grub = {
        enable = true;
        useOSProber = true;
        efiSupport = true;
        device = "nodev";
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };

    # Enable sensors
    kernelModules = [
      "coretemp"
      "k10temp"
    ];

    # Supported filesystems
    supportedFilesystems = [ "btrfs" ];
  };

  # Nix configuration: enable flakes, nix-command, and automatic garbage collection
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      substituters = [
        "https://cache.nixos.org"
        "https://nvf.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nvf.cachix.org-1:GMQWiUhZ6ux9D5CvFFMwnc2nFrUHTeGaXRlVBXo+naI="
      ];

      auto-optimise-store = true;
    };

    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };
  };

  # System, Nixpkgs, and hardware settings
  nixpkgs = {
    config.allowUnfree = true;

    # Disable deprecated package aliases to ensure only current package names are used
    config.allowAliases = false;
  };

  # Docker
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
    storageDriver = "overlay2";
  };

  hardware.bluetooth.enable = true;

  system = {
    # Make glibc resolve .local hostnames via mDNS
    nssModules = [ pkgs.nssmdns ];
    nssDatabases.hosts = [
      "files mdns4_minimal [NOTFOUND=return] dns mdns4"
    ];
  };
}
