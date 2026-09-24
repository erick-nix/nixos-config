{ ... }:

{
  # Hard drive mount
  fileSystems."/mnt/HD" = {
    device = "/dev/disk/by-uuid/088bd649-35af-498f-8b96-97e27c14a031";
    fsType = "ext4";
    options = [
      "nofail"
      "noauto"
      "x-systemd.automount"
      "x-systemd.device-timeout=1s"
    ];
  };
}
