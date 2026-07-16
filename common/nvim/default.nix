{
  pkgs,
  homeDir,
  pkgsUnstable,
  ...
}:

{
  imports = [
    ./keymaps.nix
    ./lsp.nix
    ./plugins.nix
  ];

  # packages used by nvim
  environment = {
    systemPackages = with pkgs; [
      pkgsUnstable.claude-code
      pkgsUnstable.gemini-cli
      ripgrep
    ];
  };

  programs = {
    nvf = {
      enable = true;

      settings = {
        vim = {
          theme.enable = false;
          viAlias = false;
          vimAlias = false;

          lineNumberMode = "number";

          options = {
            tabstop = 2;
            shiftwidth = 2;
            expandtab = true;
            smartindent = true;
            cmdheight = 0;
          };

          luaConfigPost = ''
            vim.o.autoread = true
            vim.api.nvim_create_autocmd("VimEnter", {
              callback = function(data)
                if vim.fn.isdirectory(data.file) == 1 then
                  vim.cmd.cd(data.file)
                end
              end,
            })

            vim.api.nvim_create_autocmd({
              "FocusGained",
              "BufEnter",
              "CursorHold",
              "CursorHoldI",
              "TermClose",
              "TermLeave",
            }, {
              command = "if mode() != 'c' | checktime | endif",
              pattern = { "*" },
            })

            local works_root = vim.fs.normalize("${homeDir}/data/work") .. "/"
            local function update_disable_format_save(bufnr)
              local path = vim.api.nvim_buf_get_name(bufnr)
              if path == "" then
                vim.b[bufnr].disableFormatSave = false
                return
              end

              path = vim.fs.normalize(path)
              vim.b[bufnr].disableFormatSave = vim.startswith(path, works_root)
            end

            vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "BufEnter" }, {
              callback = function(args)
                update_disable_format_save(args.buf)
              end,
            })
          '';
        };
      };
    };
  };
}
