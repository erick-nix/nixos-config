{ pkgs, ... }:

{
  systemd = {
    targets = {
      suspend.enable = false;
      hibernate.enable = false;
      hybrid-sleep.enable = false;
    };

    # Set permissions for the srv folder
    # sudo systemd-tmpfiles --create
    tmpfiles.rules = [
      "d /srv/media 2775 root media - -"
      "d /srv/media/Downloads 2775 root media - -"
    ];

    services.idle-session-killer = {
      description = "Terminate idle user sessions after 30 minutes";
      serviceConfig = {
        Type = "oneshot";
      };
      path = [
        pkgs.coreutils
        pkgs.gawk
        pkgs.systemd
      ];
      script = ''
        set -euo pipefail

        threshold_sec=1800
        now_usec="$(${pkgs.gawk}/bin/awk '{printf "%.0f", $1*1000000}' /proc/uptime)"

        ${pkgs.systemd}/bin/loginctl list-sessions --no-legend | ${pkgs.gawk}/bin/awk '{print $1}' | while read -r sid; do
          class="$(${pkgs.systemd}/bin/loginctl show-session "$sid" -p Class --value || true)"
          [ "$class" = "user" ] || continue

          idle="$(${pkgs.systemd}/bin/loginctl show-session "$sid" -p IdleHint --value || true)"
          [ "$idle" = "yes" ] || continue

          idle_since="$(${pkgs.systemd}/bin/loginctl show-session "$sid" -p IdleSinceHintMonotonic --value || true)"
          [ -n "$idle_since" ] || continue

          idle_age_usec=$(( now_usec - idle_since ))
          if [ "$idle_age_usec" -ge $(( threshold_sec * 1000000 )) ]; then
            ${pkgs.systemd}/bin/loginctl terminate-session "$sid"
          fi
        done
      '';
    };

    timers.idle-session-killer = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "5min";
        OnUnitActiveSec = "5min";
      };
    };
  };
}
