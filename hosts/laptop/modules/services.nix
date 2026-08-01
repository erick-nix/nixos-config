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

    # Keep battery conservation thresholds (75-80%)
    udev.extraRules = ''
      SUBSYSTEM=="power_supply", KERNEL=="BAT0", ATTR{charge_control_start_threshold}="75", ATTR{charge_control_end_threshold}="80"
    '';
  };
}
