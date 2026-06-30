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
      ];
    })

    heroic
    ruffle
    ryubing
  ];

  programs = {
    retroarch = {
      enable = true;

      cores = {
        mgba.enable = true;
        snes9x.enable = true;
        mupen64plus.enable = true;
      };

      settings = {
        menu_driver = "xmb";
      };
    };
  };
}
