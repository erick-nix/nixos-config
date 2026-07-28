{
  pkgs,
  username,
  ...
}:

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

  # Open steam with control
  systemd.user.services.steam-bigpicture = {
    description = "Wake Steam into Big Picture mode";
    partOf = [ "sway-session.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/run/current-system/sw/bin/steam steam://open/bigpicture";
    };
  };

  services.triggerhappy = {
    enable = true;
    user = "root";
    extraConfig = ''
      BTN_MODE 1 /run/current-system/sw/bin/systemctl --user --machine=${username}@.host start steam-bigpicture.service
    '';
  };
}
