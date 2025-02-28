-- NOTE: various, non-plugin config
require('user.opts_and_keys')

if not nixCats('general.always') then
  vim.notify('Category general.always is disabled.', vim.log.levels.WARN)
  return
end

-- NOTE: register an extra lze handler with the spec_field 'for_cat'
-- that makes enabling an lze spec for a category slightly nicer
require("lze").register_handlers(require('utils.lze').for_cat)

-- NOTE: general plugins
require("user.plugins")

require("user.lsp")
require("user.snacks")

if nixCats('debug') then
  require('user.debug')
end
