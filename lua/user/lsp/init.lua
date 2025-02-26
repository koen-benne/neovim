if nixCats('lspDebugMode') then
  vim.lsp.set_log_level("debug")
end

require('lze').load {
  {
    "nvim-lspconfig",
    for_cat = 'general.always',
    on_plugin = { "lazy-lsp.nvim" },
  },
  {
    "SchemaStore.nvim",
    for_cat = 'general.always',
    on_plugin = { "lazy-lsp.nvim" },
  },
  {
    "ts-error-translator.nvim",
    for_cat = 'general.always',
    on_plugin = { "lazy-lsp.nvim" },
  },
  {
    "lazy-lsp.nvim",
    for_cat = "general.always",
    event = "FileType",
    after = function(plugin)
      require('ts-error-translator').setup()
      require('user.lsp.handlers').setup()
      require('lazy-lsp').setup {
        excluded_servers = {
          'ccls',
          'zk',
        },
        -- Alternatively specify preferred servers for a filetype (others will be ignored).
        preferred_servers = {
          markdown = {},
          python = { 'basedpyright', 'ruff_lsp' },
          lua = { 'lua_ls' },
          nix = { 'nil_ls', 'nixd' },
          rust = { 'rust_analyzer' },
          json = { 'jsonls' },
          css = { 'cssmodules' },
          javascript = { 'ts_ls', 'eslint' },
          javascriptreact = { 'ts_ls', 'eslint' },
          typescript = { 'ts_ls', 'eslint' },
          typescriptreact = { 'ts_ls', 'eslint' },
          php = { 'intelephense', 'psalm' },
        },
        prefer_local = true, -- Prefer locally installed servers over nix-shell
        -- Default config passed to all servers to specify on_attach callback and other options.
        default_config = {
          flags = {
            debounce_text_changes = 150,
          },
          on_attach = require('user.lsp.handlers').on_attach,
          capabilities = require('user.lsp.handlers').capabilities,
        },
        -- Override config for specific servers that will passed down to lspconfig setup.
        -- Note that the default_config will be merged with this specific configuration so you don't need to specify everything twice.
        configs = {
          lua_ls = require('user.lsp.settings.lua_ls'),
          rust_analyzer = require('user.lsp.settings.rust'),
          clangd = require('user.lsp.settings.clangd'),
          jsonls = require('user.lsp.settings.jsonls'),
          pyright = require('user.lsp.settings.pyright'),
          emmet_ls = require('user.lsp.settings.emmet_ls'),
          intelephense = require('user.lsp.settings.intelephense'),
          nixd = require('user.lsp.settings.nixd'),
          -- cssmodules_ls = require "user.lsp.settings.cssmodules_ls",
        },
      }
    end
  }
}
