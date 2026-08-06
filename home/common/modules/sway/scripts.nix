{ pkgs, ... }:

{
  ddcBrightness = pkgs.writeShellApplication {
    name = "ddc-brightness";
    runtimeInputs = with pkgs; [
      coreutils
      ddcutil
      gawk
      gnused
      procps
      util-linux
    ];
    text = builtins.readFile ../../../../scripts/ddc-brightness.sh;
  };

  networkStatus = pkgs.writeShellApplication {
    name = "waybar-network-status";
    runtimeInputs = with pkgs; [
      gnugrep
      iproute2
    ];
    text = ''
      # Local ip, ignoring tailscale/tunnels/docker/bridges
      lan_ip() {
        ip -4 -o addr show up scope global 2>/dev/null \
          | awk '$2 !~ /^(tailscale|tun|tap|ppp|wg|docker|br-|veth)/ {print $4; exit}' \
          | cut -d/ -f1
      }

      count_vpn=0

      # Generic VPN 
      if ip -4 -o addr show up scope global 2>/dev/null | grep -qP '^\S+\s+(tun|tap|ppp|wg)'; then
        count_vpn=$((count_vpn + 1))
      fi

      # Tailscale exit-node
      default_iface=$(ip -4 route get 1.1.1.1 2>/dev/null | grep -oP 'dev \K\S+' || true)
      if [ "''${default_iface#tailscale}" != "$default_iface" ]; then
        count_vpn=$((count_vpn + 1))
      fi

      ip_addr=$(lan_ip)

      if [ -z "$ip_addr" ]; then
        echo '{"text":"OFF","class":"offline"}'
      elif [ "$count_vpn" -ge 1 ]; then
        echo "{\"text\":\"''${count_vpn}VPN~IP $ip_addr\",\"class\":\"vpn-on\"}"
      else
        echo "{\"text\":\"IP $ip_addr\",\"class\":\"vpn-off\"}"
      fi
    '';
  };

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
