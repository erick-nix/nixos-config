{ config, domain, ... }:

let
  go2rtcFile = ../../../../secrets/hosts/server/go2rtc.yaml;
in

{
  sops.secrets."go2rtc/env".sopsFile = go2rtcFile;

  systemd.services.go2rtc.serviceConfig = {
    EnvironmentFile = [ config.sops.secrets."go2rtc/env".path ];
    SupplementaryGroups = [ "keys" ];
  };

  services = {
    caddy = {
      virtualHosts = {
        "cam.${domain}".extraConfig = ''
          reverse_proxy 127.0.0.1:1984
        '';
      };
    };

    go2rtc = {
      enable = true;
      settings = {
        streams.front_door = [
          "rtsp://\${RTSP_USER}:\${RTSP_PASSWORD}@192.168.1.177:554/onvif1"
        ];
      };
    };
  };
}
