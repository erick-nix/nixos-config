# Things used at work
{
  config,
  pkgs,
  username,
  ...
}:

let
  workFile = ../../secrets/hosts/common/work.yaml;
  updateSystemdResolved = "${pkgs.update-systemd-resolved}/libexec/openvpn/update-systemd-resolved";

  openvpnWorkUp = pkgs.writeShellScript "openvpn-work-up" ''
    ${updateSystemdResolved} "$@"
    if [ -n "$trusted_ip" ]; then
      ${pkgs.iproute2}/bin/ip rule add to "$trusted_ip" lookup main pref 190 2>/dev/null || true
    fi
  '';

  openvpnWorkDown = pkgs.writeShellScript "openvpn-work-down" ''
    ${updateSystemdResolved} "$@"
    if [ -n "$trusted_ip" ]; then
      ${pkgs.iproute2}/bin/ip rule del to "$trusted_ip" lookup main pref 190 2>/dev/null || true
    fi
  '';
in

{
  sops.secrets."openvpn/config".sopsFile = workFile;
  sops.secrets."openvpn/auth".sopsFile = workFile;
  sops.secrets."work/shellrc" = {
    sopsFile = workFile;
    owner = username;
    mode = "0400";
  };

  services.openvpn.servers = {
    work = {
      autoStart = false;
      config = ''
        config ${config.sops.secrets."openvpn/config".path}
        auth-user-pass ${config.sops.secrets."openvpn/auth".path}
        mssfix 1400

        script-security 2
        setenv PATH /run/current-system/sw/bin
        up ${openvpnWorkUp}
        down ${openvpnWorkDown}
        down-pre
      '';
    };
  };

  systemd.services.openvpn-work = {
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
  };

  programs.zsh = {
    interactiveShellInit = ''
      [ -f "${config.sops.secrets."work/shellrc".path}" ] && source "${
        config.sops.secrets."work/shellrc".path
      }"
    '';
  };
}
