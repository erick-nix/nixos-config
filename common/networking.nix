{ ... }:

{
  # Networking configuration: firewall rules, wireless setup, and NetworkManager settings
  networking = {
    enableIPv6 = false;

    firewall = {
      # for VPNs
      trustedInterfaces = [ "tailscale0" ];
      checkReversePath = "loose";
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
