vim.lsp.enable('nixd')
vim.lsp.enable('lua_ls')
vim.lsp.enable('ruff')
vim.lsp.enable('pyright')

vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      diagnostics = {
        disable = { "undefined-global" },
      },
    },
  },
})

local ignored_dir = vim.fn.expand("~/data/work")

local function is_ignored(bufnr)
  local filepath = vim.api.nvim_buf_get_name(bufnr)
  return filepath:sub(1, #ignored_dir) == ignored_dir
end

-- Format on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    -- Disable in ignored folder
    if is_ignored(args.buf) then
      return
    end
    vim.lsp.buf.format { async = false, bufnr = args.buf }
  end
})

-- Disable pyright in ignored folder
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local filepath = vim.api.nvim_buf_get_name(args.buf)

    if client and client.name == "pyright" and filepath:sub(1, #ignored_dir) == ignored_dir then
      vim.lsp.buf_detach_client(args.buf, client.id)
    end
  end
})
