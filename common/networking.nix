{ ... }:

{
  # Networking configuration: firewall rules, wireless setup, and NetworkManager settings
  networking = {
    enableIPv6 = false;

    firewall = {
      # Enable the built in NixOS firewall
      enable = true;

      # for VPNs
      trustedInterfaces = [ "tailscale0" ];
      checkReversePath = "loose";

      # Allow specific TCP ports:
      # 53317 = LocalSend
      # 41641 = Tailscale (necessary)
      allowedTCPPorts = [
        53317
      ];
      allowedUDPPorts = [
        53317
        41641
      ];
    };

    networkmanager = {
      # Enable NetworkManager as the main network manager
      enable = true;

      # Disable Wi-Fi power saving mode
      # (prevents unstable connections or dropouts)
      wifi.powersave = false;
    };
  };
}
