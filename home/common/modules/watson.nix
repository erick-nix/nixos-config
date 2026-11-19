{ config, ... }:

{
  programs.watson = {
    enable = true;
  };

  home.sessionVariables.WATSON_DIR = "${config.home.homeDirectory}/data/notes/watson";
}
