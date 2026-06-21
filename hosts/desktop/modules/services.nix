{
  pkgs,
  ...
}:

{
  services = {
    # Put /dev/sda into standby after 15 minutes of inactivity (hdparm -S 180)
    udev.extraRules = ''
      ACTION=="add|change", KERNEL=="sda", ENV{DEVTYPE}=="disk", RUN+="${pkgs.hdparm}/bin/hdparm -S 180 /dev/sda"
    '';

    # Lact
    # using it because of this problem: https://wiki.nixos.org/wiki/AMD_GPU#Sporadic_Crashes
    lact.enable = true;

    # Sunshine
    sunshine = {
      enable = true;
      openFirewall = true;
      autoStart = false;
      capSysAdmin = true;
      settings = {
        origin_web_ui_allowed = "lan";
        enable_auth = false;
      };
    };
  };
}
