{
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    (prismlauncher.override {
      additionalPrograms = [ ffmpeg ];
      jdks = [
        zulu
        zulu25
      ];
    })

    heroic
    ruffle
    ryubing
  ];
}
