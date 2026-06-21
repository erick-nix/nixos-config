{ username, ... }:

{
  programs = {
    ssh = {
      extraConfig = ''
        SetEnv TERM=xterm-256color
        Host ssh.erick-nix.com
          User ${username}
          ProxyCommand cloudflared access ssh --hostname %h
      '';
    };
  };
}
