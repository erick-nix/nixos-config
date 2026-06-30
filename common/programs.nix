{ ... }:

{
  # Programs configuration: shells, browser, file manager integration, and Steam setup
  programs = {
    firefox = {
      enable = true;
      languagePacks = [
        "en-US"
        "pt-BR"
      ];

      policies = {
        # Updates & Background Services
        AppAutoUpdate = false;
        BackgroundAppUpdate = false;

        # Feature Disabling
        DisableFirefoxStudies = true;
        DisableFirefoxAccounts = true;
        DisableForgetButton = true;
        DisableMasterPasswordCreation = true;
        DisableProfileImport = true;
        DisableProfileRefresh = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DisableFormHistory = true;
        DisablePasswordReveal = true;

        # Access Restrictions
        BlockAboutConfig = false;
        BlockAboutProfiles = true;
        BlockAboutSupport = true;
      };

      preferences = {
        # BUG: https://github.com/NixOS/nixpkgs/issues/272907
        # "print.prefer_system_dialog" = true;
      };
    };

    appimage = {
      enable = true;
      binfmt = true;
    };

    nautilus-open-any-terminal = {
      enable = true;
      terminal = "ghostty";
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
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
      };

      interactiveShellInit = ''
        source ${../scripts/nr.sh}

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
