-- Set up nixInfo global early so all other modules can use it
do
  local ok
  ok, _G.nixInfo = pcall(require, vim.g.nix_info_plugin_name)
  if not ok then
    -- Non-nix compat: return the default value for any query
    package.loaded[vim.g.nix_info_plugin_name] = setmetatable({}, {
      __call = function(_, default) return default end
    })
    _G.nixInfo = require(vim.g.nix_info_plugin_name)
  end
  nixInfo.isNix = vim.g.nix_info_plugin_name ~= nil
end

-- NOTE: various, non-plugin config
require('user.opts_and_keys')

if not nixInfo(false, "settings", "cats", "general") then
  vim.notify('Category general is disabled.', vim.log.levels.WARN)
  return
end

-- NOTE: register an extra lze handler with the spec_field 'for_cat'
require("lze").register_handlers(require('utils.lze').for_cat)

-- NOTE: general plugins
require("user.plugins")

-- NOTE: snacks plugins
require("user.snacks")

-- NOTE: LSP plugins
require("user.lsp")

if nixInfo(false, "settings", "cats", "debug") then
  require('user.debug')
end
