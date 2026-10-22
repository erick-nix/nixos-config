{ pkgs, ... }:

{
  environment = {
    systemPackages = with pkgs; [
      discord
    ];
  };

  programs = {
    firejail = {
      enable = true;
      wrappedBinaries = {
        Discord = {
          executable = "${pkgs.discord}/bin/Discord";
          profile = "${pkgs.firejail}/etc/firejail/discord.profile";
          extraArgs = [
            # Allow tray icon
            "--dbus-user.talk=org.kde.StatusNotifierWatcher"
          ];
        };
      };
    };
  };
}
