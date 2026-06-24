# Things used at work
{ config, homeDir, ... }:

let
  openvpnWorkFile = ../../secrets/hosts/common/openvpn-work.yaml;
in

{
  sops.secrets."openvpn/config".sopsFile = openvpnWorkFile;
  sops.secrets."openvpn/auth".sopsFile = openvpnWorkFile;

  services.openvpn.servers = {
    work = {
      autoStart = false;
      updateResolvConf = true;
      config = ''
        config ${config.sops.secrets."openvpn/config".path}
        auth-user-pass ${config.sops.secrets."openvpn/auth".path}
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
