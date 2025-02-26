-- NOTE: various, non-plugin config
require('user.opts_and_keys')

-- NOTE: register an extra lze handler with the spec_field 'for_cat'
-- that makes enabling an lze spec for a category slightly nicer
require("lze").register_handlers(require('nixCatsUtils.lzUtils').for_cat)

-- NOTE: general plugins
-- require("user.plugins")

-- NOTE: obviously, more plugins, but more organized by what they do below

require("user.lsp")

-- NOTE: we even ask nixCats if we included our debug stuff in this setup! (we didnt)
-- But we have a good base setup here as an example anyway!
if nixCats('debug') then
  require('user.debug')
end
-- NOTE: we included these though! Or, at least, the category is enabled.
-- these contain nvim-lint and conform setups.
-- if nixCats('lint') then
--   require('user.lint')
-- end
-- if nixCats('format') then
--   require('user.format')
-- end
-- NOTE: I didnt actually include any linters or formatters in this configuration,
-- but it is enough to serve as an example.
