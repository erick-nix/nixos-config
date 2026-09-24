{
  pkgs,
  lib,
  hostname,
  pkgsUnstable,
  ...
}:

lib.mkIf (hostname == "laptop" || hostname == "desktop") {
  home.packages = with pkgs; [
    pkgsUnstable.sgdboop
    mangohud
    vkbasalt
    # Simple tool for input event debugging
    evtest

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
}
