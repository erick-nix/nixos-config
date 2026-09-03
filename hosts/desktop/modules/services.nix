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

    # Sunshine
    sunshine = {
      enable = true;
      openFirewall = true;
      autoStart = false;
      capSysAdmin = true;
      settings = {
        origin_web_ui_allowed = "lan";
        enable_auth = false;
        audio_sink = "stream_sink";
      };
    };

    # Virtual sink that mirrors system audio, used as input for Sunshine streaming
    pipewire = {
      extraConfig.pipewire."99-stream-sink" = {
        "context.objects" = [
          {
            factory = "adapter";
            args = {
              "factory.name" = "support.null-audio-sink";
              "node.name" = "stream_sink";
              "node.description" = "StreamSink";
              "media.class" = "Audio/Sink";
              "audio.position" = "FL,FR";
            };
          }
        ];

        "context.modules" = [
          {
            name = "libpipewire-module-loopback";
            args = {
              "node.description" = "StreamSink Loopback";
              "capture.props" = {
                "node.target" = "stream_sink";
                "stream.capture.sink" = true;
                "audio.position" = "FL,FR";
              };
              "playback.props" = {
                "audio.position" = "FL,FR";
                "node.passive" = true;
              };
            };
          }
        ];
      };
    };
  };
}
