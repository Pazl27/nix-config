_: {
  imports = [
    # General Configuration
    ./settings.nix
    ./keymaps.nix
    ./auto_cmds.nix

    # Themes
    ./plugins/themes

    # Completion
    ./plugins/cmp/cmp.nix
    ./plugins/cmp/cmp-copilot.nix
    ./plugins/cmp/lspkind.nix
    ./plugins/cmp/autopairs.nix
    ./plugins/cmp/schemastore.nix
    ./plugins/cmp/actions-preview.nix

    # Snippets
    ./plugins/snippets/luasnip.nix

    # Editor plugins and configurations
    ./plugins/editor/neo-tree.nix
    ./plugins/editor/treesitter.nix
    ./plugins/editor/illuminate.nix
    ./plugins/editor/indent-blankline.nix
    ./plugins/editor/todo-comments.nix
    ./plugins/editor/comment.nix
    ./plugins/editor/tmux.nix
    ./plugins/editor/copilot-chat.nix
    ./plugins/editor/navic.nix

    # UI plugins
    ./plugins/ui/bufferline.nix
    ./plugins/ui/lualine.nix
    ./plugins/ui/alpha.nix
    # ./plugins/ui/sidekick.nix

    # LSP and formatting
    ./plugins/lsp/lsp.nix
    ./plugins/lsp/fidget.nix
    ./plugins/lsp/dap.nix

    # Git
    ./plugins/git/lazygit.nix
    ./plugins/git/gitsigns.nix
    ./plugins/git/gitmesenger.nix

    # Utils
    ./plugins/utils/telescope.nix
    ./plugins/utils/whichkey.nix
    ./plugins/utils/mini.nix
    ./plugins/utils/trouble.nix
    ./plugins/utils/markdown-preview.nix
    ./plugins/utils/markview.nix
    ./plugins/utils/web-devicons.nix
    ./plugins/utils/crates.nix
    ./plugins/utils/colorizer.nix
  ];
}
