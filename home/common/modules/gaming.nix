{
  pkgs,
  lib,
  hostname,
  pkgsUnstable,
  ...
}:

lib.mkIf (hostname == "laptop" || hostname == "desktop") {
  programs.mangohud = {
    enable = true;
  };

  home.packages = with pkgs; [
    pkgsUnstable.sgdboop
    vkbasalt
    lgogdownloader
    # Simple tool for input event debugging
    evtest

    (prismlauncher.override {
      additionalPrograms = [ ffmpeg ];
      jdks = [
        zulu
        zulu25
      ];
    })

    (pkgsUnstable.heroic.override {
      extraPkgs =
        pkgs': with pkgs'; [
          gamescope
          gamemode
          mangohud
        ];
    })
  ];
}
