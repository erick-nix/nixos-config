{ ... }:

{
  imports = [
    ./ingress.nix
    ./apps.nix
    ./freshrss.nix
    ./glance.nix
    ./vaultwarden.nix
    ./jellyfin.nix
    ./romm.nix
    ./invidious.nix
    ./protonvpn.nix
    ./cameras.nix
    ./minecraft-server.nix
  ];
}
