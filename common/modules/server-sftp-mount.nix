{
  pkgs,
  homeDir,
  username,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    sshfs
  ];

  programs.fuse.userAllowOther = true;

  # Remote SFTP share mounted via SSHFS.
  fileSystems."${homeDir}/Server" = {
    device = "${username}@sftp.erick-nix.com:/srv";
    fsType = "fuse.sshfs";
    options = [
      "nofail"
      "noauto"
      "_netdev"
      "x-systemd.automount"
      "x-systemd.idle-timeout=300"
      "allow_other"
      "default_permissions"
      "uid=1000"
      "gid=100"
      "umask=022"
      "reconnect"
      "ServerAliveInterval=15"
      "ServerAliveCountMax=3"
      "IdentityFile=${homeDir}/.ssh/id_ed25519"
      "StrictHostKeyChecking=accept-new"
      "x-gvfs-hide"
    ];
  };
}
