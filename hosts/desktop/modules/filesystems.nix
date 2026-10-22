{ pkgs, ... }:

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

  # Server (samba)
  environment.systemPackages = [ pkgs.cifs-utils ];
  fileSystems."/mnt/share" = {
    device = "//192.168.1.12/server";
    fsType = "cifs";
    options =
      let
        # this line prevents hanging on network split
        automount_opts = "x-systemd.automount,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
      in
      [
        "${automount_opts},uid=1000,gid=100"
        "nofail"
      ];
  };
}
