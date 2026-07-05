{ ... }:

{
  imports = [
    ./ingress.nix
    ./apps.nix
    ./apps-docker.nix
    ./glance.nix
    ./vaultwarden.nix
    ./jellyfin.nix
    ./searx.nix
    ./romm.nix
  ];
}
