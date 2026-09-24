{ ... }:

{
  programs = {
    kdeconnect.enable = true;

    zsh.shellAliases = {
      poweroff = "echo 'Put the MOUSE on to charge!' && sleep 3 && poweroff";
    };
  };
}
