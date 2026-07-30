{ ... }:

{
  services = {
    blueman-applet = {
      enable = true;
      systemdTargets = [ "sway-session.target" ];
    };

    swayidle = {
      enable = true;
      systemdTargets = [ "sway-session.target" ];
      events = {
        before-sleep = "swaylock -f";
      };
    };

    mako = {
      enable = true;
      settings = {
        default-timeout = 5000;
        ignore-timeout = true;
        anchor = "bottom-right";
      };
    };

    wlsunset = {
      enable = true;
      temperature = {
        day = 6500;
        night = 3800;
      };
      latitude = -19.9167;
      longitude = -43.9345;
    };
  };
}
