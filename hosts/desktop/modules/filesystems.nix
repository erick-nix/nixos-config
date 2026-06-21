{ homeDir, ... }:

{
  # Hard drive mount
  fileSystems."/mnt/sda1" = {
    device = "/dev/disk/by-uuid/088bd649-35af-498f-8b96-97e27c14a031";
    fsType = "ext4";
    options = [
      "nofail"
      "noauto"
      "x-systemd.automount"
      "x-systemd.device-timeout=1s"
    ];
  };

  # Games subvolume (Btrfs)
  fileSystems."${homeDir}/Games" = {
    device = "/dev/disk/by-uuid/bfa1e520-d219-4547-9542-58bb604f9d84";
    fsType = "btrfs";
    options = [
      "subvol=games"
      "compress=zstd"
      "noatime"
      "x-gvfs-hide"
      "nofail"
      "noauto"
      "x-systemd.automount"
      "x-systemd.device-timeout=15s"
    ];
  };

  # Documents subvolume (Btrfs)
  fileSystems."${homeDir}/Documents" = {
    device = "/dev/disk/by-uuid/bfa1e520-d219-4547-9542-58bb604f9d84";
    fsType = "btrfs";
    options = [
      "subvol=documents"
      "compress=zstd"
      "noatime"
      "x-gvfs-hide"
      "nofail"
      "noauto"
      "x-systemd.automount"
      "x-systemd.device-timeout=15s"
    ];
  };
}
