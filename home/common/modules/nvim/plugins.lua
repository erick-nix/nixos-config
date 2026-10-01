require("colorizer").setup()

require("nvim-autopairs").setup()

require('Comment').setup()

require("gitsigns").setup()

require("oil").setup({
  keymaps = {
    ["<C-s>"] = {},
  },

  view_options = {
    show_hidden = true,
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
    ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
  },
  sources = {
    providers = {
      path     = { score_offset = 3, },
      snippets = { score_offset = 1 },
      lsp      = { score_offset = 0, },
      buffer   = { score_offset = -3 },
    },
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

local ignored_dir = vim.fn.resolve(vim.fn.expand("~/data/work"))

local function is_ignored(bufnr)
  local filepath = vim.fn.resolve(vim.api.nvim_buf_get_name(bufnr))
  return filepath:sub(1, #ignored_dir + 1) == ignored_dir .. "/"
end

require('conform').setup({
  formatters_by_ft = {
    javascript = { 'prettier' },
    typescript = { 'prettier' },
    html       = { 'prettier' },
    css        = { 'prettier' },
    vue        = { 'prettier' },
    svelte     = { 'prettier' },
    astro      = { 'prettier' },
  },
  format_on_save = function(bufnr)
    if is_ignored(bufnr) then
      return
    end
    return { timeout_ms = 1000, lsp_format = 'fallback' }
  end,
})

require("nvim-treesitter").setup()
vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    pcall(vim.treesitter.start)
  end,
})
