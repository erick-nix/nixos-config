{
  config,
  pkgs,
  username,
  ...
}:

{
  users.users.${username} = {
    extraGroups = [
      "video"
    ];
  };

  boot = {
    extraModulePackages = [ config.boot.kernelPackages.ddcci-driver ];
    kernelModules = [
      "ddcci"
      "ddcci_backlight"
    ];
  };

  services = {
    udev.extraRules = ''
      SUBSYSTEM=="backlight", KERNEL=="ddcci*", GROUP="video", MODE="0664", TAG+="uaccess"
    '';
  };

  # Kernel >= 6.8 no longer autoprobe ddcci monitors reliably.
  # Bind known monitor buses at boot so /sys/class/backlight/ddcci* appears.
  systemd.services.ddcci-bind = {
    description = "Bind DDC/CI monitors to ddcci";
    wantedBy = [ "multi-user.target" ];
    wants = [ "display-manager.service" ];
    after = [
      "systemd-modules-load.service"
      "display-manager.service"
      "ly.service"
    ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      ${pkgs.kmod}/bin/modprobe ddcci ddcci_backlight >/dev/null 2>&1 || true

      # Displays can be late during boot. Retry until ddcci backlights appear.
      for _ in $(seq 1 40); do
        for bus in 6 8; do
          node="/sys/bus/i2c/devices/i2c-$bus"
          [ -e "$node/new_device" ] || continue
          [ -w "$node/delete_device" ] && echo "0x37" > "$node/delete_device" 2>/dev/null || true
          [ -w "$node/new_device" ] && echo "ddcci 0x37" > "$node/new_device" 2>/dev/null || true
        done

        if [ -e /sys/class/backlight/ddcci6 ] && [ -e /sys/class/backlight/ddcci8 ]; then
          exit 0
        fi
        sleep 3
      done
    '';
    path = [
      pkgs.coreutils
      pkgs.kmod
    ];
  };
}
