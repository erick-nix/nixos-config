{
  lib,
  pkgs,
  username,
  hostname,
  ...
}:

{
  home-manager.users.${username}.imports =
    lib.optionals (hostname == "laptop" || hostname == "desktop") [
      ../../home/common/modules/gaming.nix
    ]
    ++ lib.optionals (hostname == "desktop") [
      ../../home/desktop/modules/emulators.nix
    ];

  boot = {
    kernel.sysctl = {
      "vm.max_map_count" = 2147483642;
    };

    kernelModules = [
      "ntsync"
    ];
  };

  environment.sessionVariables = {
    __GL_SHADER_DISK_CACHE_SIZE = "12000000000";
    __GL_SHADER_DISK_CACHE_SKIP_CLEANUP = "1";
  };

  programs = {
    gamescope = {
      enable = true;
      capSysNice = false;
    };

    gamemode = {
      enable = true;
      settings = { };
    };

    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      extraCompatPackages = with pkgs; [ proton-ge-bin ];
    };
  };
}
