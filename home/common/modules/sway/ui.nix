{
  pkgs,
  ...
}:

let
  scripts = import ./scripts.nix { inherit pkgs; };
in

{
  # Theme programs
  programs = {
    swaylock = {
      enable = true;
      package = pkgs.swaylock-effects;
      settings = {
        color = "161821";

        indicator = true;
        indicator-radius = 120;
        indicator-thickness = 10;
        indicator-idle-visible = true;

        clock = true;
        timestr = "%R";
        datestr = "%a %d/%m/%Y";

        inside-color = "1e2132";
        ring-color = "3d425b";
        ring-clear-color = "e2a478";
        ring-ver-color = "91acd1";
        ring-wrong-color = "e27878";
        line-uses-ring = true;

        text-color = "c6c8d1";
        text-clear-color = "c6c8d1";
        text-ver-color = "c6c8d1";
        text-wrong-color = "c6c8d1";

        key-hl-color = "84a0c6";
        bs-hl-color = "e2a478";
        separator-color = "00000000";
      };
    };

    fuzzel = {
      enable = true;
      settings = {
        main = {
          terminal = "ghostty";
          layer = "overlay";
          anchor = "center";
          font = "Cascadia Code:size=12";
          "horizontal-pad" = 22;
          "line-height" = 18;
          "vertical-pad" = 20;
          "inner-pad" = 10;
        };
        border = {
          width = 1;
          radius = 3;
        };
        colors = {
          background = "161821ff";
          text = "c6c8d1ff";
          match = "91acd1ff";
          selection = "272c42ff";
          selection-text = "c6c8d1ff";
          selection-match = "84a0c6ff";
          border = "6f88b7ff";
        };
      };
    };

    waybar = {
      enable = true;
      systemd.enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "bottom";
          height = 30;
          spacing = 6;

          modules-left = [
            "custom/nixos"
            "sway/workspaces"
            "sway/mode"
            "sway/window"
          ];

          # modules-right is defined per-host in ./hosts/*.nix

          "custom/nixos" = {
            format = "{}";
            justify = "center";
            tooltip = false;
            interval = 3600;
            exec = "${pkgs.bash}/bin/bash -lc 'echo '";
          };

          "custom/network" = {
            interval = 5;
            "return-type" = "json";
            justify = "center";
            tooltip = false;
            exec = "${scripts.networkStatus}/bin/waybar-network-status";
          };

          "sway/workspaces" = {
            disable-scroll = false;
            all-outputs = true;
            format = "{name}";
          };

          "sway/mode" = {
            format = "MODE: {}";
          };

          "sway/window" = {
            max-length = 60;
          };

          "pulseaudio" = {
            format = "VOL {volume}%";
            format-muted = "VOL MUTE";
            justify = "center";
            scroll-step = 5;
            on-click = "${pkgs.pwvucontrol}/bin/pwvucontrol";
            on-click-right = "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          };

          "custom/cpu_temp" = {
            interval = 10;
            format = "CPU {}";
            justify = "center";
            exec = "${pkgs.bash}/bin/bash -lc \"${pkgs.lm_sensors}/bin/sensors k10temp-pci-00c3 | ${pkgs.gawk}/bin/awk '/Tctl:/ {print \\$2; exit}'\"";
          };

          "cpu" = {
            interval = 2;
            format = "CPU {usage}%";
            justify = "center";
          };

          "memory" = {
            interval = 5;
            format = "MEM {}%";
            justify = "center";
          };

          "disk#root" = {
            path = "/";
            interval = 30;
            format = "FREE {free}";
            justify = "center";
          };

          "clock" = {
            interval = 60;
            format = "{:%a %d/%m %R}";
            justify = "center";
            tooltip-format = "<tt>{calendar}</tt>";
            calendar = {
              mode = "month";
              mode-mon-col = 3;
              on-scroll = 1;
            };
          };

          backlight = {
            format = "BRI {percent}%";
            on-scroll-up = "";
            on-scroll-down = "";
          };

          "tray" = {
            icon-size = 14;
            spacing = 8;
          };
        };
      };

      style = ''
        * {
          border: none;
          border-radius: 0;
          min-height: 0;
          font-family: "Cascadia Code";
          font-size: 12px;
        }

        window#waybar {
          background: #161821;
          color: #c6c8d1;
          border: none;
          box-shadow: none;
        }

        #workspaces button {
          background: #1e2132;
          color: #6b7089;
          padding: 0 8px;
          border-radius: 4px;
          margin: 4px 2px;
        }

        #workspaces button.focused {
          background: #272c42;
          color: #c6c8d1;
        }

        #workspaces button.urgent {
          background: #53343b;
          color: #ffffff;
        }

        #mode {
          background: #392313;
          color: #ffffff;
          padding: 0 10px;
          margin: 4px 0;
        }

        #window {
          color: #c6c8d1;
          padding: 0 6px;
          margin: 4px 0;
        }

        #custom-brightness,
        #custom-network,
        #backlight,
        #pulseaudio,
        #battery,
        #custom-cpu_temp,
        #cpu,
        #memory,
        #disk,
        #clock,
        #tray {
          color: #c6c8d1;
          padding: 0px 5px 0px 10px;
          margin: 4px 0;
          border-left: 1px solid #3d425b;
        }

        #tray {
          margin: 0px 12px 0px 0px;
        }

        #custom-nixos {
          font-size: 26px;
          padding: 0px 3px 0px 14px;
        }

        #custom-nixos, #custom-network.vpn-off, #custom-network.vpn-on {
          color: #91acd1;
        }

        #battery {
          color: #b4be82;
        }

        #battery.warning {
          color: #e2a478;
        }

        #battery.critical{
          color: #e27878;
        }

        #custom-network.offline {
          color: #80828b;
        }
      '';
    };
  };

  # Theme Sway
  wayland.windowManager.sway = {
    config = {
      # Set apps to open in windowed mode.
      window.commands = [
        {
          criteria = {
            app_id = "blueman-manager";
          };
          command = "floating enable, resize set 900 600, move position center";
        }
      ];

      fonts = {
        names = [
          "Cascadia Code"
        ];
        size = 9.0;
      };

      colors = {
        background = "#161821";
        focused = {
          border = "#6f88b7";
          background = "#1e2132";
          text = "#c6c8d1";
          indicator = "#91acd1";
          childBorder = "#1e2132";
        };

        focusedInactive = {
          border = "#3d425b";
          background = "#272c42";
          text = "#c6c8d1";
          indicator = "#6b7089";
          childBorder = "#272c42";
        };

        unfocused = {
          border = "#3d425b";
          background = "#1e2132";
          text = "#6b7089";
          indicator = "#242940";
          childBorder = "#1e2132";
        };

        urgent = {
          border = "#e27878";
          background = "#53343b";
          text = "#ffffff";
          indicator = "#e27878";
          childBorder = "#53343b";
        };

        placeholder = {
          border = "#000000";
          background = "#0f1117";
          text = "#c6c8d1";
          indicator = "#000000";
          childBorder = "#0f1117";
        };
      };

      bars = [ ];
    };
  };
}
