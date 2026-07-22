{ lib, ... }:

{
  networking = {
    # Hostname
    hostName = "server";

    # Disable wi-fi
    wireless.enable = lib.mkForce false;

    firewall = {
      allowedTCPPorts = [
        22 # SSH
      ];

      allowedUDPPorts = [ ];
    };
  };
}
