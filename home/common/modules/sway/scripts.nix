{ pkgs, ... }:

{
  btMenu = pkgs.writeShellApplication {
    name = "bt-menu";
    runtimeInputs = with pkgs; [
      bash
      bluez
      coreutils
      fuzzel
      gnugrep
      gnused
      libnotify
    ];
    text = ''
      # Toggle Bluetooth devices using a fuzzel menu.
      set -euo pipefail

      powered="off"
      if bluetoothctl show | grep -q "Powered: yes"; then
        powered="on"
      fi

      actions="󰂯 Turn on Bluetooth\n󰂲 Turn off Bluetooth\nDevice sniffing"
      devices="$(
        bluetoothctl devices \
          | sed 's/^Device //'
      )"

      selected="$(
        printf '%b\n%s\n' "$actions" "$devices" \
          | fuzzel --dmenu --prompt "Bluetooth ($powered): "
      )"

      [ -z "''${selected:-}" ] && exit 0

      case "$selected" in
        "󰂯 Turn on Bluetooth")
          bluetoothctl power on >/dev/null
          notify-send "Bluetooth" "On fire!"
          exit 0
          ;;
        "󰂲 Turn off Bluetooth")
          bluetoothctl power off >/dev/null
          notify-send "Bluetooth" "Sleep"
          exit 0
          ;;
        "Device sniffing")
          bluetoothctl power on >/dev/null
          bluetoothctl scan on >/dev/null
          notify-send "Bluetooth" "Scanning for new devices"
          exit 0
          ;;
      esac

      mac="''${selected%% *}"
      name="''${selected#* }"

      if bluetoothctl info "$mac" | grep -q "Connected: yes"; then
        bluetoothctl disconnect "$mac" >/dev/null
        notify-send "Bluetooth" "Disconnected: $name"
      else
        bluetoothctl connect "$mac" >/dev/null
        notify-send "Bluetooth" "Connected: $name"
      fi
    '';
  };
}
