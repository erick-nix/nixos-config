{ pkgs, ... }:

{
  programs = {
    dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/desktop/interface" = {
            text-scaling-factor = 1.25;
          };

          "org/gnome/mutter" = {
            experimental-features = [
              "scale-monitor-framebuffer"
              "xwayland-native-scaling"
            ];
          };
        };
      }
    ];

    # Scale GDM
    dconf.profiles.gdm.databases = [
      {
        settings = {
          "org/gnome/desktop/interface" = {
            scaling-factor = pkgs.lib.gvariant.mkUint32 1;
            text-scaling-factor = 1.25;
          };

          "org/gnome/mutter" = {
            experimental-features = [ "scale-monitor-framebuffer" ];
          };
        };
      }
    ];
  };
}
