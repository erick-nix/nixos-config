{ ... }:

{
  services = {
    # ThinkFan
    thinkfan = {
      enable = true;
      fans = [
        {
          type = "tpacpi";
          query = "/proc/acpi/ibm/fan";
        }
      ];
    };

    # To update the BIOS
    fwupd.enable = true;
  };
}
