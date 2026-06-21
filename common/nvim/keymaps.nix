{ ... }:

{
  programs.nvf.settings.vim.keymaps = [
    # > / < : keep visual selection after indenting
    {
      key = ">";
      mode = "v";
      action = ">gv";
      silent = true;
    }

    {
      key = "<";
      mode = "v";
      action = "<gv";
      silent = true;
    }

    # Ctrl+Shift+C : copy selected text
    {
      key = "<C-S-c>";
      mode = "v";
      action = "\"+y";
      silent = true;
    }

    # Ctrl+C : disabled
    {
      key = "<C-c>";
      mode = "v";
      action = "<Nop>";
      silent = true;
    }

    # Ctrl+X : cut selected text
    {
      key = "<C-x>";
      mode = "v";
      action = "\"+d";
      silent = true;
    }

    # Ctrl+V : paste in insert mode
    {
      key = "<C-v>";
      mode = "i";
      action = "<C-r>+";
      silent = true;
    }

    # Leader+Q : quit current window
    {
      key = "<leader>q";
      mode = "n";
      action = "<cmd>q<CR>";
      silent = true;
    }

    # Leader+SR : grug-far
    {
      key = "<leader>sr";
      mode = "n";
      action = "<cmd>GrugFar<CR>";
      silent = true;
    }

    # Esc : exit terminal mode
    {
      key = "<Esc>";
      mode = "t";
      action = "<C-\\><C-n>";
      silent = true;
    }

    # Esc : clear search highlight
    {
      key = "<Esc>";
      mode = "n";
      action = "<cmd>nohlsearch<CR>";
      silent = true;
    }

    # Ctrl+Left : before tab
    {
      key = "<C-Left>";
      mode = "n";
      action = "<cmd>tabprevious<CR>";
      silent = true;
    }

    # Ctrl+Right : next tab
    {
      key = "<C-Right>";
      mode = "n";
      action = "<cmd>tabnext<CR>";
      silent = true;
    }

    # Shift+Left/Right : jump by word in insert mode and start selection
    {
      key = "<S-Left>";
      mode = "i";
      action = "<Esc>ghb";
      silent = true;
    }

    {
      key = "<S-Right>";
      mode = "i";
      action = "<Esc>ghe";
      silent = true;
    }

    # Shift+Left/Right : expand selection by word in visual/select mode
    {
      key = "<S-Left>";
      mode = [
        "v"
        "s"
      ];
      action = "b";
      silent = true;
    }

    {
      key = "<S-Right>";
      mode = [
        "v"
        "s"
      ];
      action = "e";
      silent = true;
    }

    # Leader+E : open/close file explorer
    {
      key = "<leader>e";
      mode = "n";
      action = "<cmd>Oil<CR>";
      silent = true;
    }

    # Leader+V : open vertical split to the right
    {
      key = "<leader>v";
      mode = "n";
      action = "<cmd>rightbelow vsplit<CR>";
      silent = true;
    }

    # Ctrl+S : save file
    {
      key = "<C-s>";
      mode = [
        "n"
        "i"
      ];
      action = "<cmd>silent w<CR>";
      silent = true;
    }

    # Space+L+F: format file
    {
      key = "<leader>lf";
      mode = [
        "n"
        "v"
      ];
      action = "<cmd>lua vim.lsp.buf.format()<CR>";
      silent = true;
    }

    # Ctrl+Backspace : delete previous word in insert mode
    {
      key = "<C-BS>";
      mode = [
        "i"
        "t"
      ];
      action = "<C-w>";
      silent = true;
    }

    # Alt+Left : move to left window
    {
      key = "<A-Left>";
      mode = "n";
      action = "<C-w>h";
      silent = true;
    }

    # Alt+Right : move to right window
    {
      key = "<A-Right>";
      mode = "n";
      action = "<C-w>l";
      silent = true;
    }

    # Alt+Up : move current line / selected block up
    {
      key = "<A-Up>";
      mode = "n";
      action = "<cmd>move .-2<CR>==";
      silent = true;
    }

    {
      key = "<A-Up>";
      mode = "v";
      action = "<cmd>move '<-2<CR>gv=gv";
      silent = true;
    }

    # Alt+O : go to previous file
    {
      key = "<A-o>";
      mode = "n";
      action = "<C-^>";
      silent = true;
    }

    # K : show diagnostic message in popup
    {
      key = "K";
      mode = "n";
      action = "<cmd>lua vim.diagnostic.open_float()<CR>";
      silent = true;
    }

    # Leader+L : show LSP hover
    {
      key = "<leader>l";
      mode = "n";
      action = "<cmd>lua vim.lsp.buf.hover()<CR>";
      silent = true;
    }

    # gi : go to definition (VSCode ctrl+click style)
    {
      key = "gi";
      mode = "n";
      action = "<cmd>lua vim.lsp.buf.definition()<CR>";
      silent = true;
    }

    # Create new numbered terminal
    {
      key = "<A-j>";
      mode = [
        "n"
        "i"
        "t"
      ];
      action = "<cmd>1ToggleTerm direction=float<CR>";
      silent = true;
    }

    {
      key = "<A-k>";
      mode = [
        "n"
        "i"
        "t"
      ];
      action = "<cmd>lua local cwd = vim.fn.getcwd(); local cmd = (cwd == '/etc/nixos') and 'sudo codex' or 'codex'; local Terminal = require('toggleterm.terminal').Terminal; if not _G.codex_term or _G.codex_term.cmd ~= cmd then _G.codex_term = Terminal:new({ cmd = cmd, count = 2, direction = 'float', hidden = true }); end; _G.codex_term:toggle()<CR>";
      silent = true;
    }

    # <leader>fs : open telescope lsp_document_symbols
    {
      key = "<leader>fs";
      mode = "n";
      action = "<cmd>Telescope lsp_document_symbols<CR>";
      silent = true;
    }

    # Ctrl+Down : next git hunk (gitsigns)
    {
      key = "<C-Down>";
      mode = "n";
      action = "<cmd>Gitsigns next_hunk<CR>";
      silent = true;
    }

    # Ctrl+Up : previous git hunk (gitsigns)
    {
      key = "<C-Up>";
      mode = "n";
      action = "<cmd>Gitsigns prev_hunk<CR>";
      silent = true;
    }

    # Shift+Up/Down : smooth scroll (cinnamon)
    {
      key = "<S-Up>";
      mode = "n";
      action = "<C-u>";
      noremap = false;
      silent = true;
    }

    {
      key = "<S-Down>";
      mode = "n";
      action = "<C-d>";
      noremap = false;
      silent = true;
    }

    # <leader>gr : reset hunk (gitsigns)
    {
      key = "<leader>gr";
      mode = "n";
      action = "<cmd>Gitsigns reset_hunk<CR>";
      silent = true;
    }

    # Tabs
    {
      key = "<leader>tn";
      mode = "n";
      action = "<cmd>tabnew<CR>";
      silent = true;
    }

    {
      key = "<leader>tq";
      mode = "n";
      action = "<cmd>tabclose<CR>";
      silent = true;
    }

    # Ctrl+Z : disable suspend (do nothing)
    {
      key = "<C-z>";
      mode = [
        "n"
        "i"
      ];
      action = "<Nop>";
      silent = true;
    }
  ];
}
