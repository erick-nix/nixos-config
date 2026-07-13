{ ... }:

{
  systemd.user.services.varredura-web = {
    Unit = {
      Description = "Varredura Web tray";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "/home/erick-nix/.nix-profile/bin/verredura-web --tray-only";
      Restart = "on-failure";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
