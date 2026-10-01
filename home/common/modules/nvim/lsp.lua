vim.lsp.enable({ 'nixd', 'lua_ls', 'ruff', 'pyright', 'html', 'cssls', 'tailwindcss' })

vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      diagnostics = {
        disable = { "undefined-global" },
      },
    },
  },
})

vim.lsp.config('html', {
  filetypes = { 'html', 'astro' },
})

-- Enable (broadcasting) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

for _, server in ipairs({ 'html', 'cssls' }) do
  vim.lsp.config(server, {
    capabilities = capabilities,
  })
end
