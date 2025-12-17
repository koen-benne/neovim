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

      -- Configure default settings for all LSP servers using new vim.lsp.config API
      vim.lsp.config('*', {
        flags = {
          debounce_text_changes = 150,
        },
        on_attach = require('user.lsp.handlers').on_attach,
        capabilities = require('user.lsp.handlers').capabilities,
      })

      -- Configure server-specific settings using new vim.lsp.config API
      vim.lsp.config('lua_ls', require('user.lsp.settings.lua_ls'))
      vim.lsp.config('rust_analyzer', require('user.lsp.settings.rust'))
      vim.lsp.config('clangd', require('user.lsp.settings.clangd'))
      vim.lsp.config('jsonls', require('user.lsp.settings.jsonls'))
      vim.lsp.config('pyright', require('user.lsp.settings.pyright'))
      vim.lsp.config('emmet_ls', require('user.lsp.settings.emmet_ls'))
      vim.lsp.config('intelephense', require('user.lsp.settings.intelephense'))
      vim.lsp.config('nixd', require('user.lsp.settings.nixd'))
      vim.lsp.config('ruby_lsp', require('user.lsp.settings.ruby_lsp'))

      require('lazy-lsp').setup {
        use_vim_lsp_config = true, -- Use new Neovim 0.11+ vim.lsp.config API
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
          css = { 'cssmodules_ls' },
          javascript = { 'ts_ls', 'eslint' },
          javascriptreact = { 'ts_ls', 'eslint' },
          typescript = { 'ts_ls', 'eslint' },
          typescriptreact = { 'ts_ls', 'eslint' },
          php = { 'intelephense', 'psalm' },
          kotlin = { 'kotlin_language_server' },
          ruby = { 'ruby_lsp' }
        },
        prefer_local = true, -- Prefer locally installed servers over nix-shell
      }
    end
  }
}
