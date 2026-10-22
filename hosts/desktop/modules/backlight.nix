{
  config,
  pkgs,
  username,
  ...
}:

{
  hardware.brillo.enable = true;

  boot = {
    kernelModules = [
      "i2c"
      "ddcci"
      "ddcci_backlight"
    ];

    extraModulePackages = with config.boot.kernelPackages; [
      ddcci-driver
    ];
  };

  services.udev.extraRules = ''
    SUBSYSTEM=="i2c", ACTION=="add", ATTR{name}=="NVIDIA i2c adapter *", RUN+="${pkgs.systemd}/bin/systemd-run --no-block ${pkgs.bash}/bin/bash -c 'sleep 30; echo 0x37 > /sys/bus/i2c/devices/%k/delete_device 2>/dev/null; echo ddcci 0x37 > /sys/bus/i2c/devices/%k/new_device'"
  '';

  security.sudo.extraRules = [
    {
      users = [ username ];
      commands = [
        {
          command = "${pkgs.systemd}/bin/udevadm trigger --subsystem-match=i2c --action=add";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
}
