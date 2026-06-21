{ ... }:

{
  services = {
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
