{ ... }:

{
  imports = [
    ./ingress.nix
    ./apps.nix
    ./glance.nix
    ./vaultwarden.nix
    ./jellyfin.nix
    ./searx.nix
    ./romm.nix
    ./invidious.nix
    ./protonvpn.nix
    ./minecraft-server.nix
  ];
}
