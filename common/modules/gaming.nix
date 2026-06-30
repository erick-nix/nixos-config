{ pkgs, ... }:

{
  programs = {
    gamescope = {
      enable = true; # gamescope %command%
      capSysNice = false;
    };

    gamemode = {
      enable = true; # gamemoderun %command%
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
