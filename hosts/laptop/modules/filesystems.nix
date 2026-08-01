{ homeDir, ... }:

{
  # Games subvolume (Btrfs)
  fileSystems."${homeDir}/Games" = {
    device = "/dev/disk/by-uuid/18b37992-847f-4c44-867a-66693cda1583";
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
}
