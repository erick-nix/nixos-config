# Core system settings: bootloader, kernel, locale, user, nix options

{ lib, username, ... }:

{
  powerManagement.cpuFreqGovernor = "performance";

  boot = {
    kernelModules = [
      "kvm-amd"
    ];
  };

  swapDevices = [
    { device = "/swap/swapfile"; }
  ];

  i18n = {
    defaultLocale = lib.mkForce "pt_BR.UTF-8";
  };

  # for use in nrremote
  nix.settings.trusted-users = [
    "root"
    "erick-nix"
  ];

  # allow git and nh to run without sudo, it is useful for the nrremote command.
  security.sudo.extraRules = [
    {
      users = [ "${username}" ];
      commands = [
        {
          command = "/run/current-system/sw/bin/git";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/run/current-system/sw/bin/nh";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  system = {
    # DO NOT change this after install — keeps compatibility with old data
    stateVersion = "25.11";
  };
}
