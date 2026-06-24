{ homeDir, ... }:

{
  systemd.timers."files-cleanup" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };

  systemd.services."files-cleanup" = {
    script = ''
      set -euo pipefail

      DATA_DIR="${homeDir}/data"
      CSV_DIR="${homeDir}/data/work/workfolder/chatbot-api/docs"

      find "$DATA_DIR" \
        -type f -name "*.log" \
        -mtime +1 -delete

      find "$CSV_DIR" \
        -type f -name "*.csv" \
        -mtime +1 -delete
    '';
  };
}
