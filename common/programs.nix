{ ... }:

{
  # Programs configuration: shells, browser, file manager integration, and Steam setup
  programs = {
    dconf.enable = true;

    zsh = {
      enable = true;
      enableCompletion = false;

      interactiveShellInit = ''
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

    localsend = {
      enable = true;
      openFirewall = true;
    };
  };
}
