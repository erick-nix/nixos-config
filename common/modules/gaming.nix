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

  boot.kernel.sysctl = {
    "vm.max_map_count" = 262144;
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

  # Open steam with control
  systemd.user.services.steam-bigpicture = {
    description = "Wake Steam into Big Picture mode";
    partOf = [ "sway-session.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "steam-bigpicture-start" ''
        if ${pkgs.procps}/bin/pgrep -x steam >/dev/null; then
          ${pkgs.procps}/bin/pkill -x steam
          while ${pkgs.procps}/bin/pgrep -x steam >/dev/null; do
            sleep 0.5
          done
        fi
        exec /run/current-system/sw/bin/gamescope -e -f -W 1920 -H 1080 -w 1920 -h 1080 -- /run/current-system/sw/bin/steam
      '';
    };
  };

  services.triggerhappy = {
    enable = true;
    user = "root";
    extraConfig = ''
      BTN_GAMEPAD+BTN_START 1 /run/current-system/sw/bin/systemctl --user --machine=${username}@.host start steam-bigpicture.service
    '';
  };
}
