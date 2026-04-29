if nixCats('lspDebugMode') then
  vim.lsp.set_log_level("debug")
end

require('lze').load {
  -- nvim-lspconfig is loaded purely for its lsp/*.lua default configs,
  -- which Neovim 0.11+ picks up automatically. We do NOT call require('lspconfig').
  {
    "nvim-lspconfig",
    for_cat = 'general.always',
    event = "FileType",
  },
  {
    "SchemaStore.nvim",
    for_cat = 'general.always',
    event = "FileType",
  },
  {
    "ts-error-translator.nvim",
    for_cat = 'general.always',
    event = "FileType",
    after = function()
      require('ts-error-translator').setup()
    end,
  },
}

-- Set up LSP handlers/diagnostics config
require('user.lsp.handlers').setup()

-- Global defaults for all servers
vim.lsp.config('*', {
  flags = {
    debounce_text_changes = 150,
  },
  on_attach = require('user.lsp.handlers').on_attach,
  capabilities = require('user.lsp.handlers').capabilities,
})

-- Server-specific overrides (only where we differ from lspconfig defaults)
vim.lsp.config('lua_ls',        require('user.lsp.settings.lua_ls'))
vim.lsp.config('rust_analyzer', require('user.lsp.settings.rust'))
vim.lsp.config('jsonls',        require('user.lsp.settings.jsonls'))
vim.lsp.config('basedpyright',  require('user.lsp.settings.basedpyright'))
vim.lsp.config('emmet_ls',      require('user.lsp.settings.emmet_ls'))
vim.lsp.config('intelephense',  require('user.lsp.settings.intelephense'))
vim.lsp.config('nixd',          require('user.lsp.settings.nixd'))
vim.lsp.config('ruby_lsp',      require('user.lsp.settings.ruby_lsp'))

-- Enable servers. nvim-lspconfig's lsp/*.lua files provide cmd/filetypes/root_dir defaults.
vim.lsp.enable({
  -- React / JS / TS
  'ts_ls',
  'eslint',
  'cssls',
  'html',
  'emmet_ls',
  -- Go
  'gopls',
  -- Nix
  'nixd',
  -- Lua
  'lua_ls',
  -- Rust
  'rust_analyzer',
  -- Python
  'basedpyright',
  'ruff',
  -- Bash
  'bashls',
  -- Fish
  'fish_lsp',
  -- PHP
  'intelephense',
  -- JSON (used across many filetypes)
  'jsonls',
  -- Ruby (binary comes from project ruby env, not nix)
  'ruby_lsp',
})
