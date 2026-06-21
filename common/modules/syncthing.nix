{
  hostname,
  username,
  homeDir,
  lib,
  ...
}:

let
  devices = {
    desktop = "EO2BGAP-M2OAVHP-KQW6LX5-6KGVU2A-7QKAEUA-T5W5D6X-GQUOKVD-JA32OQC";
    server = "PXDEENG-FVKSP3V-YCA3NCD-UQUULR4-MRX53Y4-7KFX7OA-SFO6XQV-RWX2AQ2";
    laptop = "ZWKZTMA-UFLXM2F-RTCO5YL-KFCDDLA-2TIMF5B-BTXSQ5K-FV4ESTT-E244LAT";
  };

  type = if hostname == "server" then "receiveonly" else "sendreceive";
  path = if hostname == "server" then "/srv/syncthing" else "${homeDir}/Documents";
  isServer = hostname == "server";

  otherDevices = lib.filterAttrs (name: _: name != hostname) devices;

  stignoreText = ''
    workfolder
    .snapshots
    u01

    (?d).git

    (?d)node_modules
    (?d).angular
    (?d)vendor
    (?d).venv
    (?d)venv

    (?d)dist
    (?d)build
    (?d)target
    (?d)out
    (?d)release
    (?d)debug
    (?d)logs
    (?d)exports

    (?d)__pycache__
    (?d)*.pyc
    (?d)*.pyo
    (?d)*.pyd
    (?d)*.log
    (?d).mypy_cache
    (?d).pytest_cache

    (?d)npm-debug.log
    (?d)yarn-error.log
    (?d).pnpm-store

    (?d).direnv

    (?d)result
    (?d)result-*
    (?d).nix-profile
    (?d).nix-defexpr

    (?d)*.o
    (?d)*.a
    (?d)*.so
    (?d)*.out
    (?d)*.dylib

    (?d)bin
    (?d)pkg

    (?d)builddir
    (?d)_build
    (?d)CMakeFiles
    (?d)CMakeCache.txt
    (?d)cmake-build-*

    (?d).vscode
    (?d).idea

    (?d)*.swp
    (?d)*.swo

    (?d).DS_Store
    (?d)Thumbs.db
  '';
in

{
  services.syncthing = {
    enable = true;
    user = username;
    group = "users";
    dataDir = homeDir;
    configDir = "${homeDir}/.config/syncthing";
    overrideDevices = true;
    overrideFolders = true;
    settings = {
      ignorePerms = true;
      devices = lib.mapAttrs (name: id: { inherit id; }) otherDevices;
      folders = {
        Documents = {
          path = path;
          devices = lib.attrNames otherDevices;
          type = type;
        };
      };
    };
  };

  home-manager.users.${username} = lib.mkIf (!isServer) {
    home.file."Documents/.stignore".text = stignoreText;
  };
}
