{ ... }:

{
  services = {
    samba = {
      enable = true;
      openFirewall = true;
      settings = {
        global = {
          "workgroup" = "WORKGROUP";
          "server string" = "smbnix";
          "netbios name" = "smbnix";
          "map to guest" = "Bad User";
          "security" = "user";

          "server min protocol" = "NT1";
          "client min protocol" = "NT1";
          "ntlm auth" = "yes";
          "lanman auth" = "no";

          "hosts allow" = "192.168.1. 127.0.0.1 localhost";
          "hosts deny" = "0.0.0.0/0";
        };

        server = {
          "path" = "/srv/samba";
          "browseable" = "yes";
          "read only" = "no";
          "guest ok" = "yes";
          "guest only" = "yes";
          "force user" = "erick-nix";
          "create mask" = "0664";
          "directory mask" = "0775";
        };
      };
    };

    # Prevent automatic suspension
    logind = {
      settings = {
        Login = {
          KillUserProcesses = true;
          KillOnlyUsers = [
            "eduardo"
            "erick-nix"
          ];
          IdleAction = "lock";
          IdleActionSec = "30min";
          HandleLidSwitch = "ignore";
          HandleLidSwitchDocked = "ignore";
        };
      };
    };
  };
}
