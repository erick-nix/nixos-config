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
}
