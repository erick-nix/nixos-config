{ pkgs, hostname, ... }:

{
  programs.nvf.settings.vim = {
    languages = {
      enableFormat = true;
      enableTreesitter = true;

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
        lsp = {
          servers = [ "basedpyright" ];
        };

        extraDiagnostics = {
          enable = false;
        };
      };

      nix = {
        enable = true;

        format = {
          enable = true;
          type = [ "nixfmt" ];
        };
      };
    };

    lsp = {
      enable = true;
      formatOnSave = true;

      servers = {
        nixd = {
          enable = true;
          cmd = [ "${pkgs.nixd}/bin/nixd" ];
          root_markers = [
            ".git"
            "flake.nix"
          ];
          settings = {
            nixd = {
              nixpkgs.expr = "import <nixpkgs> { }";
              formatting.command = [ "nixfmt" ];
              options = {
                nixos.expr = ''(builtins.getFlake "/etc/nixos").nixosConfigurations.${hostname}.options'';
                "home-manager".expr =
                  ''(builtins.getFlake "/etc/nixos").nixosConfigurations.${hostname}.options.home-manager.users.type.getSubOptions []'';
              };
            };
          };
        };

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
