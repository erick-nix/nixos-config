vim.opt.number = true
vim.opt.clipboard = "unnamedplus"

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.termguicolors = true
vim.cmd.colorscheme("iceberg")

vim.opt.cmdheight = 0
vim.api.nvim_set_hl(0, 'SnippetTabstop', {})

-- Fix spacing in Gitsigns
vim.opt.signcolumn = "yes:1"
