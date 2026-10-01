{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    withRuby = false;
    withPython3 = false;

    extraPackages = with pkgs; [
      ripgrep
      luaPackages.tree-sitter-cli

      # LSP
      # https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
      nixd
      lua-language-server

      # Python
      ruff
      pyright

      # HTML
      prettier
      vscode-langservers-extracted
      tailwindcss-language-server
    ];

    plugins = with pkgs.vimPlugins; [
      iceberg-vim

      nvim-lspconfig
      nvim-colorizer-lua
      nvim-web-devicons
      blink-cmp
      lualine-nvim
      telescope-nvim
      oil-nvim
      gitsigns-nvim
      comment-nvim
      toggleterm-nvim
      nvim-autopairs
      friendly-snippets
      conform-nvim

      (nvim-treesitter.withPlugins (p: [
        p.html
        p.css
        p.typescript
        p.vue
        p.astro
        p.nix
        p.lua
        p.bash
        p.python
        p.markdown
        p.markdown_inline
      ]))
    ];

    initLua = ''
      ${builtins.readFile ./options.lua}
      ${builtins.readFile ./plugins.lua}
      ${builtins.readFile ./lsp.lua}
      ${builtins.readFile ./keybindings.lua}
    '';
  };
}
