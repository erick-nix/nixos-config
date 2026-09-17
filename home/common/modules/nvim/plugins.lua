require("colorizer").setup()

require("nvim-autopairs").setup()

require('Comment').setup()

require("gitsigns").setup()

require("oil").setup({
  keymaps = {
    ["<C-s>"] = {},
  },
})

require("toggleterm").setup({
  start_in_insert = true,
  shell = "sudo -u erick-nix $SHELL",

  float_opts = {
    height = 24,
  },
})

require('blink.cmp').setup({
  keymap = {
    preset = 'enter',
    ['<CR>'] = { 'select_and_accept', 'fallback' },
    ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
  },
})

require("lualine").setup({
  options = {
    theme = "iceberg",
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
  },
  extensions = {
    "toggleterm",
    "oil",
  },
})

require('telescope').setup {
  defaults = {
    layout_config = {
      horizontal = {
        preview_width = 0.5,
      },
    },
  },

  pickers = {
    find_files = {
      hidden = true,
      find_command = {
        "rg",
        "--files",
        "--hidden",
        "--glob",
        "!.git/*",
      },
    },

    git_status = {
      path_display = { "tail" },
    },
  },
}

require("nvim-treesitter").setup()
vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    pcall(vim.treesitter.start)
  end,
})
