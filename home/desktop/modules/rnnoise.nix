{ pkgs, ... }:

let
  inherit (pkgs) rnnoise-plugin;
in

{
  home.packages = [ rnnoise-plugin ];

  systemd.user.services.set-brio-volume = {
    Unit = {
      Description = "Set Brio microphone volume to 150%";
      After = [
        "pipewire.service"
        "pipewire-pulse.service"
      ];
    };

    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.writeShellScript "set-brio-volume" ''
        for i in $(seq 1 30); do
          if ${pkgs.pulseaudio}/bin/pactl list short sources | grep -q "alsa_input.usb-046d_Brio_105"; then
            break
          fi
          sleep 1
        done

        ${pkgs.pulseaudio}/bin/pactl set-source-volume \
          alsa_input.usb-046d_Brio_105_2526ZBT1R388-02.mono-fallback \
          150%
      ''}";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  xdg.configFile."pipewire/pipewire.conf.d/99-rnnoise.conf" = {
    text = ''
      context.modules = [
        { name = libpipewire-module-filter-chain
          flags = [ nofail ]
          args = {
            node.description = "Noise Canceling source"
            media.name = "Noise Canceling source"
            filter.graph = {
              nodes = [
                {
                  type = ladspa
                  name = rnnoise
                  plugin = librnnoise_ladspa
                  label = noise_suppressor_mono
                  control = {
                    "VAD Threshold (%)" = 80.0
                    "VAD Grace Period (ms)" = 200
                    "Retroactive VAD Grace (ms)" = 0
                  }
                }
              ]
            }
            capture.props = {
              node.name = "capture.rnnoise_source"
              node.passive = true
              audio.rate = 48000
            }
            playback.props = {
              node.name = "rnnoise_source"
              media.class = "Audio/Source"
              audio.rate = 48000
            }
          }
        }
      ]
    '';
  };

  xdg.configFile."systemd/user/pipewire.service.d/zz-rnnoise.conf" = {
    text = ''
      [Service]
      Environment=LADSPA_PATH=${rnnoise-plugin}/lib/ladspa
    '';
  };
}
