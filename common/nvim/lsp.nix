{
  pkgs,
  hostname,
  lib,
  ...
}:

{
  programs.nvf.settings.vim = {
    languages = {
      enableFormat = true;
      enableTreesitter = true;

      nix.enable = true;
      html.enable = true;
      css.enable = true;
      typescript.enable = true;
      tsx.enable = true;
      json.enable = true;
      php.enable = true;
      vue.enable = true;
      bash.enable = true;
      astro.enable = true;
      yaml.enable = true;
      markdown.enable = true;
      toml.enable = true;
      xml.enable = true;
      lua.enable = true;
      rust.enable = true;
      clang.enable = true;

      python = {
        enable = true;

        extraDiagnostics = {
          enable = false;
        };
      };
    };

    lsp = {
      enable = true;
      formatOnSave = true;

      servers = {
        "basedpyright" = {
          enable = true;
          settings = {
            basedpyright = {
              analysis = {
                typeCheckingMode = "basic";
                reportUnknownArgumentType = "none";
                reportUnknownMemberType = "none";
                reportUnknownVariableType = "none";
                reportUnknownParameterType = "none";
                reportArgumentType = "none";
                diagnosticSeverityOverrides = {
                  reportUnknownArgumentType = "none";
                  reportUnknownMemberType = "none";
                  reportUnknownVariableType = "none";
                  reportUnknownParameterType = "none";
                  reportArgumentType = "none";
                };
              };
            };
          };
        };
      };

      presets = {
        tailwindcss-language-server.enable = true;
        angular-language-server.enable = true;
      };
    };

    treesitter = {
      enable = true;
      # change in the future
      grammars = pkgs.vimPlugins.nvim-treesitter.allGrammars;
    };
  };
}
