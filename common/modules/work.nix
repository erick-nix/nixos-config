# Things used at work
{
  config,
  pkgs,
  homeDir,
  ...
}:

let
  openvpnWorkFile = ../../secrets/hosts/common/openvpn-work.yaml;
  updateSystemdResolved = "${pkgs.update-systemd-resolved}/libexec/openvpn/update-systemd-resolved";

  openvpnWorkUp = pkgs.writeShellScript "openvpn-work-up" ''
    ${updateSystemdResolved} "$@"
    if [ -n "$trusted_ip" ]; then
      ${pkgs.iproute2}/bin/ip rule add to "$trusted_ip" lookup main pref 190 2>/dev/null || true
    fi
  '';

  openvpnWorkDown = pkgs.writeShellScript "openvpn-work-down" ''
    ${updateSystemdResolved} "$@"
    if [ -n "$trusted_ip" ]; then
      ${pkgs.iproute2}/bin/ip rule del to "$trusted_ip" lookup main pref 190 2>/dev/null || true
    fi
  '';
in

{
  sops.secrets."openvpn/config".sopsFile = openvpnWorkFile;
  sops.secrets."openvpn/auth".sopsFile = openvpnWorkFile;

  services.openvpn.servers = {
    work = {
      autoStart = false;
      config = ''
        config ${config.sops.secrets."openvpn/config".path}
        auth-user-pass ${config.sops.secrets."openvpn/auth".path}
        mssfix 1400

        script-security 2
        setenv PATH /run/current-system/sw/bin
        up ${openvpnWorkUp}
        down ${openvpnWorkDown}
        down-pre
      '';
    };
  };

  systemd.services.openvpn-work = {
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
  };

  programs.zsh = {
    shellAliases = {
      work = "cd ${homeDir}/data/work";
      chat-work = "docker start chat && docker exec -it chat python app.py";
      token-work = "docker start redacted-container && docker exec -it redacted-container python app.py";
      product-work = "docker start redacted-container && cd ${homeDir}/data/work/workfolder/redacted-product/frontend && npm run serve";
      teka-work = "cd ${homeDir}/data/work/workfolder/redacted-project && npm run start";
    };

    interactiveShellInit = ''
      stop-work() {
        echo "Closing work environment..."

        echo "Stopping OpenVPN..."
        sudo systemctl stop openvpn-work.service

        echo "Stopping Docker containers..."
        docker stop chat >/dev/null 2>&1
        docker stop redacted-container >/dev/null 2>&1
        docker stop redacted-container >/dev/null 2>&1
        docker stop redacted-container >/dev/null 2>&1
        docker stop redacted-container >/dev/null 2>&1

        echo "Environment closed."
      }
    '';
  };
}
