{ ... }:

{
  # Hostname
  networking.hostName = "laptop";

  networking = {
    wireless.iwd.enable = true;
    networkmanager = {
      wifi.backend = "iwd";
    };
  };
}
