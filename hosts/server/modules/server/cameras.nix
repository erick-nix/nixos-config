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

  systemd.services.frigate.serviceConfig.EnvironmentFile = [
    config.sops.secrets."go2rtc/env".path
  ];

  services = {
    caddy = {
      virtualHosts = {
        "cam.${domain}".extraConfig = ''
          reverse_proxy 127.0.0.1:1984
        '';
        "frigate.${domain}".extraConfig = ''
          reverse_proxy 127.0.0.1:8971
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

    frigate = {
      enable = true;
      hostname = "frigate.${domain}";
      vaapiDriver = "radeonsi";

      settings = {
        ffmpeg.hwaccel_args = "preset-vaapi";

        go2rtc.streams.front_door = [
          "rtsp://{RTSP_USER}:{RTSP_PASSWORD}@192.168.1.177:554/onvif1"
        ];

        cameras.front_door = {
          ffmpeg.inputs = [
            {
              path = "rtsp://127.0.0.1:8554/front_door";
              input_args = "preset-rtsp-restream";
              roles = [
                "detect"
                "record"
              ];
            }
          ];

          record = {
            enabled = true;
            retain.days = 7;
            alerts.retain.days = 30;
          };

          objects.filters.person.threshold = 0.8;
        };
      };
    };

    nginx.virtualHosts."frigate.${domain}".listen = [
      {
        addr = "127.0.0.1";
        port = 8971;
      }
    ];
  };
}
