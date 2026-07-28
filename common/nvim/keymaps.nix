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

    # Ctrl+Shift+V : paste from system clipboard
    {
      key = "<C-S-v>";
      mode = [
        "n"
        "i"
        "v"
      ];
      action = "<C-r>+";
      silent = true;
    }

    # Ctrl+Shift+C : copy selected text
    {
      key = "<C-S-c>";
      mode = [
        "v"
      ];
      action = "\"+y";
      silent = true;
    }

    # Ctrl+X : cut selected text
    {
      key = "<C-x>";
      mode = [
        "v"
      ];
      action = "\"+d";
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

    # Leader+m : multicursors.nvim
    {
      key = "<leader>m";
      mode = [
        "n"
        "v"
      ];
      action = "<cmd>MCstart<CR>";
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

    # Space+F: format file
    {
      key = "<leader>f";
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

    # gi : go to definition
    {
      key = "gi";
      mode = "n";
      action = "<cmd>lua vim.lsp.buf.definition()<CR>";
      silent = true;
    }

    # go back (voltar do ponto da definição)
    {
      key = "go";
      mode = "n";
      action = "<C-o>";
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
      action = "<cmd>lua local cwd = vim.fn.getcwd(); local cmd = (cwd == '/etc/nixos') and 'sudo claude' or 'claude'; local Terminal = require('toggleterm.terminal').Terminal; if not _G.claude_term or _G.claude_term.cmd ~= cmd then _G.claude_term = Terminal:new({ cmd = cmd, count = 2, direction = 'float', hidden = true }); end; _G.claude_term:toggle()<CR>";
      silent = true;
    }

    # Ctrl+Left : focus left split
    {
      key = "<C-Left>";
      mode = "n";
      action = "<C-w>h";
      silent = true;
    }

    # Ctrl+Right : focus right split
    {
      key = "<C-Right>";
      mode = "n";
      action = "<C-w>l";
      silent = true;
    }

    # Ctrl+Up : focus upper split
    {
      key = "<C-Up>";
      mode = "n";
      action = "<C-w>k";
      silent = true;
    }

    # Ctrl+Down : focus lower split
    {
      key = "<C-Down>";
      mode = "n";
      action = "<C-w>j";
      silent = true;
    }

    # Leader+PA : copy absolute path of current file to clipboard
    {
      key = "<leader>pa";
      mode = "n";
      action = "<cmd>let @+=expand('%:p')<CR>";
      silent = true;
    }

    # Leader+PR : copy relative path of current file to clipboard
    {
      key = "<leader>pr";
      mode = "n";
      action = "<cmd>let @+=expand('%')<CR>";
      silent = true;
    }

    # Shift+Enter (terminal mode) : send line break
    {
      key = "<S-CR>";
      mode = "t";
      action = "<Esc><CR>";
      silent = true;
    }
  ];
}
