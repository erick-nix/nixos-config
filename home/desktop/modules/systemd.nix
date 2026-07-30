{ lib, ... }:

{
  systemd.user.services.olhudo = {
    Unit = {
      Description = "olhudo";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "/home/erick-nix/.nix-profile/bin/olhudo --tray-only";
      Restart = "on-failure";
    };

    Install = {
      # WantedBy = [ "graphical-session.target" ];
      WantedBy = lib.mkForce [ ];
    };
  };
}
