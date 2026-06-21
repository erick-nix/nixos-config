{ ... }:

{
  systemd = {
    services.sops-install-secrets = {
      unitConfig.ConditionPathExists = "/root/.config/sops/age/keys.txt";
    };

    services."syncthing-init".serviceConfig.TimeoutStartSec = "30s";
  };
}
