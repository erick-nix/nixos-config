{
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    (heroic.override {
      extraPkgs = pkgs: [
        pkgs.mangohud
        pkgs.gamescope
      ];
    })
    (prismlauncher.override {
      additionalPrograms = [ ffmpeg ];
      jdks = [
        zulu
      ];
    })

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
