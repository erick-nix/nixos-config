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
      nixd
      lua-language-server
      ruff
      pyright
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

      (nvim-treesitter.withPlugins (p: [
        p.html
        p.css
        p.typescript
        p.vue
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
