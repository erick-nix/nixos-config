{ ... }:

{
  services = {
    blueman-applet.enable = true;

    mako = {
      enable = true;
      settings = {
        default-timeout = 5000;
        ignore-timeout = true;
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
