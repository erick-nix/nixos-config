{ ... }:

{
  imports = [
    ./ingress.nix
    ./apps.nix
    ./glance.nix
    ./vaultwarden.nix
    ./jellyfin.nix
    ./romm.nix
    ./invidious.nix
    ./protonvpn.nix
    ./go2rtc.nix
    ./minecraft-server.nix
  ];
}
