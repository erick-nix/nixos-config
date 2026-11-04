# Things used at work
{
  config,
  username,
  ...
}:

let
  workFile = ../../secrets/hosts/common/work.yaml;
in

{
  sops.secrets."work/shellrc" = {
    sopsFile = workFile;
    owner = username;
    mode = "0400";
  };

  programs.zsh = {
    interactiveShellInit = ''
      [ -f "${config.sops.secrets."work/shellrc".path}" ] && source "${
        config.sops.secrets."work/shellrc".path
      }"
    '';
  };
}
