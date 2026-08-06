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

    heroic
  ];
}
