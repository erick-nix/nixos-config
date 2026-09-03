{
  pkgs,
  lib,
  hostname,
  ...
}:

lib.mkIf (hostname == "laptop" || hostname == "desktop") {
  home.packages = with pkgs; [
    (prismlauncher.override {
      additionalPrograms = [ ffmpeg ];
      jdks = [
        zulu
        zulu25
      ];
    })

    (heroic.override {
      extraPkgs =
        pkgs': with pkgs'; [
          gamescope
          gamemode
          mangohud
        ];
    })
  ];

  # Sway
  wayland.windowManager.sway.config.window.commands = [
    {
      criteria.app_id = "^steam_app_.*$";
      command = "fullscreen enable";
    }
    {
      criteria.class = "^steam_app_.*$";
      command = "fullscreen enable";
    }
    {
      criteria.app_id = "^steam_app_.*$";
      command = "allow_tearing yes";
    }
    {
      criteria.class = "^steam_app_.*$";
      command = "allow_tearing yes";
    }
  ];
}
