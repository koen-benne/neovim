if nixInfo(false, "info", "lspDebugMode") then
  vim.lsp.set_log_level("debug")
end

require('lze').load {
  {
    "lsp-setup",
    for_cat = 'general',
    on_plugin = { "blink.cmp" },
    load = function(_)
      vim.cmd.packadd("nvim-lspconfig")
      vim.cmd.packadd("SchemaStore.nvim")
      vim.cmd.packadd("ts-error-translator-nvim")
    end,
    after = function()
      require('ts-error-translator').setup()
      require('user.lsp.handlers').setup()

      vim.lsp.config('*', {
        flags = {
          debounce_text_changes = 150,
        },
        on_attach = require('user.lsp.handlers').on_attach,
        capabilities = require('user.lsp.handlers').capabilities,
      })

      vim.lsp.config('lua_ls',        require('user.lsp.settings.lua_ls'))
      vim.lsp.config('rust_analyzer', require('user.lsp.settings.rust'))
      vim.lsp.config('jsonls',        require('user.lsp.settings.jsonls'))
      vim.lsp.config('basedpyright',  require('user.lsp.settings.basedpyright'))
      vim.lsp.config('emmet_ls',      require('user.lsp.settings.emmet_ls'))
      vim.lsp.config('intelephense',  require('user.lsp.settings.intelephense'))
      vim.lsp.config('nixd',          require('user.lsp.settings.nixd'))
      vim.lsp.config('ruby_lsp',      require('user.lsp.settings.ruby_lsp'))

      vim.lsp.enable({
        'ts_ls',
        'eslint',
        'cssls',
        'html',
        'emmet_ls',
        'gopls',
        'nixd',
        'lua_ls',
        'rust_analyzer',
        'basedpyright',
        'ruff',
        'bashls',
        'fish_lsp',
        'intelephense',
        'jsonls',
        'ruby_lsp',
      })
    end,
  },
}
