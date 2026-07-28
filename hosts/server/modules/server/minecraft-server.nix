{ pkgs, lib, ... }:

{
  services = {
    minecraft-server = {
      enable = true;
      package = pkgs.papermcServers.papermc;
      eula = true;
      openFirewall = true;
      declarative = true;
      serverProperties = {
        max-players = 5;
        motd = "NixOS Minecraft server!";
      };
      jvmOpts = "-Xms512M -Xmx8192M";
    };
  };

  systemd = {
    services = {
      # Prevent the server from turning on automatically
      minecraft-server.wantedBy = lib.mkForce [ ];

      minecraft-server-autostop = {
        description = "Stop Minecraft server when idle (no players)";
        after = [ "minecraft-server.service" ];
        serviceConfig.Type = "oneshot";
        path = [
          pkgs.mcstatus
          pkgs.jq
        ];
        script = ''
          set -euo pipefail

          if ! systemctl is-active --quiet minecraft-server.service; then
            exit 0
          fi

          online=$(mcstatus 127.0.0.1 json | jq '.status.players.online // 0')

          if [ "$online" -eq 0 ]; then
            systemctl stop minecraft-server.service
          fi
        '';
      };
    };

    timers.minecraft-server-autostop = {
      description = "Periodically check Minecraft server for idle players";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "5min";
        OnUnitActiveSec = "5min";
      };
    };
  };
}
