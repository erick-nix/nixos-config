{ pkgs, ... }:

let
  novpnRun = pkgs.writeShellScriptBin "novpn-run" ''
    exec systemd-run --user --scope -p Slice=novpn.slice --unit="novpn-$(${pkgs.coreutils}/bin/date +%s%N)" --collect -- "$@"
  '';
in

{
  home.packages = [ novpnRun ];

  xdg.desktopEntries.librewolf-novpn = {
    name = "LibreWolf (noVPN)";
    genericName = "Web Browser";
    comment = "LibreWolf without the Tailscale/Proton exit-node";
    exec = "${novpnRun}/bin/novpn-run librewolf --new-instance -P novpn --class=librewolf-novpn %U";
    icon = "librewolf";
    categories = [
      "Network"
      "WebBrowser"
    ];
    terminal = false;
  };
}
