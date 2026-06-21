{
  pkgs,
  homeDir,
  lib,
  inputs,
  ...
}:

{
  imports = [
    inputs.plasma-manager.homeModules.plasma-manager
  ];

  # KDE packages
  home.packages = lib.mkAfter (
    with pkgs;
    [
      kdePackages.plasma-systemmonitor
      kdePackages.polkit-kde-agent-1
    ]
  );

  # Plasma-Manager
  programs.plasma = {
    enable = true;

    # Set wallpaper
    workspace.wallpaper = [
      "${homeDir}/.config/background"
    ];

    # Do not restore session
    configFile."ksmserverrc".General = {
      loginMode = "emptySession";
    };

    shortcuts = {
      kwin = {
        "Close Window" = [
          "Alt+F4"
          "Meta+q"
        ];
      };
    };

    # Hotkeys
    hotkeys.commands = {
      konsole = {
        name = "ghostty";
        key = "Meta+x";
        command = "ghostty";
      };
    };
  };
}
