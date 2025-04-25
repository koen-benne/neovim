local function faster_get_path(name)
  local path = vim.tbl_get(package.loaded, "nixCats", "pawsible", "allPlugins", "opt", name)
  if path then
    vim.cmd.packadd(name)
    return path
  end
  return nil -- nil will make it default to normal behavior
end

---packadd + after/plugin
---@type fun(names: string[]|string)
local load_w_after_plugin = require('lzextras').make_load_with_afters({ "plugin" }, faster_get_path)

-- NOTE: packadd doesnt load after directories.
-- hence, the above function that you can get from luaUtils that exists to make that easy.

return {
  {
    "luasnip",
    for_cat = 'general.cmp',
    dep_of = { "blink.cmp" },
    after = function (plugin)
      local luasnip = require 'luasnip'
      require('luasnip.loaders.from_vscode').lazy_load()
      luasnip.config.setup {}

      local ls = require('luasnip')

      vim.keymap.set({ "i", "s" }, "<M-n>", function()
          if ls.choice_active() then
              ls.change_choice(1)
          end
      end)
    end,
  },
  {
    "blink.cmp",
    for_cat = 'general.cmp',
    -- cmd = { "" },
    event = { "DeferredUIEnter" },
    dep_of = { "lazy-lsp.nvim" },
    on_require = { "cmp" },
    -- ft = "",
    -- keys = "",
    -- colorscheme = "",
    after = function (plugin)
      local blink = require 'blink.cmp'

      blink.setup({
        enabled = function()
          return not vim.tbl_contains({ "markdown" }, vim.bo.filetype)
            and vim.bo.buftype ~= 'prompt'
          end,
        completion = {
          keyword = { range = 'full' },
          trigger = { show_on_trigger_character = true },
          list = { selection = { preselect = true, auto_insert = true } },
          documentation = { auto_show = true, auto_show_delay_ms = 500 },
        },

        keymap = {
          preset = 'super-tab',
        },

        sources = {
          default = { 'lsp', 'path', 'snippets', 'buffer' },
          per_filetype = {
            codecompanion = { 'codecompanion' },
          },
        },

        snippets = { preset = 'luasnip' },
        signature = { enabled = true },
      })
    end,
  },
}
