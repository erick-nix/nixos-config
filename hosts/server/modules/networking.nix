{ lib, ... }:

{
  networking = {
    enableIPv6 = false;

    # Hostname
    hostName = "server";

    # Disable wi-fi
    wireless.enable = lib.mkForce false;

    firewall = {
      allowedTCPPorts = [
        22 # SSH
        2283 # Immich
        8096 # Jellyfin
        8080 # Miniflux
        8443 # Crafty Control
        25565 # Minecraft
        11434 # Ollama
        111
        2049
        4000
        4001
        4002 # nfs
      ];

      allowedUDPPorts = [
        11434 # Ollama
        25565 # Minecraft
        111
        2049
        4000
        4001
        4002 # nfs
      ];
    };
  };
}
