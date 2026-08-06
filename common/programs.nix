{ homeDir, ... }:

{
  # Programs configuration: shells, browser, file manager integration, and Steam setup
  programs = {
    dconf.enable = true;

    git = {
      enable = true;
      config = {
        rerere.enabled = true;
      };
    };

    appimage = {
      enable = true;
      binfmt = true;
    };

    direnv = {
      enable = true;
      silent = true;
      nix-direnv.enable = true;
    };

    localsend = {
      enable = true;
      openFirewall = true;
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      histSize = 10000;

      shellAliases = {
        ll = "ls -l";
        la = "ls -la";
        n = "nvim .";
        nr = "cd /etc/nixos && sudo nvim .";
        y = "yazi";
        notes = "cd ${homeDir}/data/shared/notes";
        pm = "cd ${homeDir}/data/programming/projects";
        check-store = "nix-store --gc --print-dead | xargs du -shc 2>/dev/null | tail -n1";
      };

      interactiveShellInit = ''
        source ${../scripts/nr.sh}
        bindkey -e

        # Shift + arrows
        bindkey -M emacs '^[[1;2D' backward-word
        bindkey -M emacs '^[[1;2C' forward-word

        # Ctrl + arrows
        bindkey -M emacs '^[[1;5D' backward-word
        bindkey -M emacs '^[[1;5C' forward-word

        # Backspace
        bindkey -M emacs '^H' backward-kill-word
      '';

      promptInit = ''
        PS1="%{$(tput setaf 250)$(tput setaf 250)%}%n%{$(tput sgr0)$(tput setaf 250)%}@%{$(tput setaf 243)%}%m %{$(tput bold)$(tput setaf 33)%}%1~ %{$(tput sgr0)%}$ "
      '';
    };
  };
}
