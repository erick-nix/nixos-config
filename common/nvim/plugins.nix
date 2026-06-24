{
  pkgs,
  lib,
  username,
  ...
}:

{
  programs.nvf.settings.vim = {
    autopairs.nvim-autopairs.enable = true;

    autocomplete.blink-cmp = {
      enable = true;
      friendly-snippets.enable = true;
      setupOpts = {
        keymap = {
          preset = "enter";
          "<CR>" = [
            "select_and_accept"
            "fallback"
          ];
        };

        snippets = {
          preset = "luasnip";
        };

        sources = {
          default = [
            "snippets"
            "lsp"
            "path"
            "buffer"
          ];
        };
      };
    };

    snippets.luasnip = {
      enable = true;
      loaders = ''
        require("luasnip.loaders.from_vscode").lazy_load()
        local ls = require("luasnip")
        local s = ls.snippet
        local t = ls.text_node
        local i = ls.insert_node

        ls.add_snippets("python", {
          s("prn", {
            t('print("\\n\\n")'),
            t({ "", "print(" }),
            i(1),
            t(')'),
            t({ "", 'print("\\n\\n")' }),
          }),
        })

        ls.add_snippets("html", {
          s("class", { t('class="'), i(1), t('"') }),
        })

        ls.filetype_extend("typescriptreact", { "html" })
        ls.filetype_extend("javascriptreact", { "html" })
      '';
    };

    ui = {
      colorizer = {
        enable = true;
        setupOpts = {
          filetypes = {
            "*" = { };
          };
        };
      };
    };

    utility = {
      grug-far-nvim = {
        enable = true;
        setupOpts = {
          minSearchChars = 1;
        };
      };

      oil-nvim = {
        enable = true;
        setupOpts = {
          columns = [ "icon" ];
          view_options = {
            show_hidden = true;
          };
          keymaps = {
            "<C-s>" = lib.mkLuaInline "false";
            "cd" = "actions.cd";
          };
        };
      };
    };

    git = {
      enable = true;
      gitsigns = {
        enable = true;
        mappings = {
          nextHunk = "<A-Down>";
          previewHunk = "<A-Up>";
          resetHunk = "<leader>gr";
        };

        setupOpts = {
          current_line_blame = true;
          current_line_blame_opts = {
            virt_text_pos = "eol";
            delay = 200;
          };
        };
      };

      git-conflict.enable = true;
    };

    terminal.toggleterm = {
      enable = true;
      setupOpts = {
        direction = "float";
        start_in_insert = true;
        persist_mode = true;
        close_on_exit = false;
        shell = "sudo -u ${username} sh -c 'cd \"$(pwd)\" && exec $SHELL'";

        float_opts = {
          height = 24;
        };
      };
    };

    comments.comment-nvim = {
      enable = true;
      mappings = {
        toggleSelectedLine = "<leader>/";
      };
    };

    telescope = {
      enable = true;
      mappings = {
        findFiles = "<leader>ff";
        liveGrep = "<leader>ss";
        gitBranches = "<leader>gb";
        gitCommits = "<leader>gc";
        gitStatus = "<leader>gs";
        gitBufferCommits = "<leader>gx";
        lspDocumentSymbols = "<leader>fs";
      };

      setupOpts = {
        defaults = {
          sorting_strategy = "descending";
          layout_strategy = "horizontal";

          layout_config = {
            horizontal = {
              prompt_position = "bottom";
            };
          };

          file_ignore_patterns = [
            "node_modules"
            "%.git/"
            "%.direnv/"
            "%.bmp$"
            "%.gif$"
            "%.ico$"
            "%.jpe?g$"
            "%.pdf$"
            "%.png$"
            "%.svg$"
            "%.avif$"
            "%.webp$"
          ];
        };

        pickers = {
          find_files = {
            hidden = true;
            find_command = [
              "rg"
              "--files"
              "--hidden"
              "--glob"
              "!.git/*"
            ];
          };
          git_status = {
            path_display = [ "tail" ];
          };
        };
      };
    };

    statusline.lualine = {
      enable = true;
      setupOpts = {
        extensions = lib.mkForce [
          "toggleterm"
          "oil"
        ];
      };
      activeSection = {
        a = [ ''{ "mode" }'' ];

        b = [
          ''{ "branch" }''
          ''{ "diff" }''
        ];

        c = [
          ''
            {
              "filename",
              path = 1,
            }
          ''
        ];

        x = [
          ''{ "encoding" }''
          ''{ "fileformat" }''
          ''{ "filetype" }''
        ];

        y = [ ''{ "progress" }'' ];
        z = [ ''{ "location" }'' ];
      };
    };

    extraPlugins = {
      iceberg-vim = with pkgs.vimPlugins; {
        package = iceberg-vim;
        setup = ''
          vim.o.background = "dark"
          vim.cmd.colorscheme("iceberg")
        '';
      };
    };
  };
}
