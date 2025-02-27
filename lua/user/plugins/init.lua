local colorschemeName = nixCats('colorscheme')

if colorschemeName == 'kanagawa' then
  require('kanagawa').setup {
    compile = true, -- enable compiling the colorscheme
    undercurl = true, -- enable undercurls
    commentStyle = { italic = true },
    functionStyle = {},
    keywordStyle = { italic = true },
    statementStyle = { bold = true },
    typeStyle = {},
    transparent = false, -- do not set background color
    dimInactive = false, -- dim inactive window `:h hl-NormalNC`
    terminalColors = true, -- define vim.g.terminal_color_{0,17}
    colors = { -- add/modify theme and palette colors
      palette = {},
      theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
    },
    overrides = function(colors) -- add/modify highlights
      return {}
    end,
    theme = 'wave', -- Load "wave" theme when 'background' option is not set
  }
end

vim.cmd.colorscheme(colorschemeName)

---Indicators for special modes,
---@return string status
local function extra_mode_status()
  -- recording macros
  local reg_recording = vim.fn.reg_recording()
  if reg_recording ~= '' then
    return ' @' .. reg_recording
  end
  -- executing macros
  local reg_executing = vim.fn.reg_executing()
  if reg_executing ~= '' then
    return ' @' .. reg_executing
  end
  return ''
end

require('lualine').setup({
  globalstatus = true,
  sections = {
    lualine_c = {
      { extra_mode_status },
    },
  },
  options = {
    theme = colorschemeName,
    path = 1,
  },
  extensions = { 'fugitive', 'fzf', 'toggleterm', 'quickfix' },
})

if nixCats('general.extra') then
  require('persistence').setup()
end

---------------------------------------------------------------------------------------------------
-- Lazy loaded plugins
---------------------------------------------------------------------------------------------------
require('lze').load {
  { import = "user.plugins.treesitter", },
  { import = "user.plugins.completion", },
  { import = "user.plugins.ufo", },
  {
    "promise-async",
    for_cat = 'general.always',
    dep_of = 'nvim-ufo',
  },
  {
    "markdown-preview.nvim",
    for_cat = 'general.markdown',
    cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle", },
    ft = "markdown",
    keys = {
      {"<leader>mp", "<cmd>MarkdownPreview <CR>", mode = {"n"}, noremap = true, desc = "markdown preview"},
      {"<leader>ms", "<cmd>MarkdownPreviewStop <CR>", mode = {"n"}, noremap = true, desc = "markdown preview stop"},
      {"<leader>mt", "<cmd>MarkdownPreviewToggle <CR>", mode = {"n"}, noremap = true, desc = "markdown preview toggle"},
    },
    before = function(plugin)
      vim.g.mkdp_auto_close = 0
    end,
  },
  {
    "undotree",
    for_cat = 'general.extra',
    cmd = { "UndotreeToggle", "UndotreeHide", "UndotreeShow", "UndotreeFocus", "UndotreePersistUndo", },
    keys = { { "<leader>U", "<cmd>UndotreeToggle<CR>", mode = { "n" }, desc = "Undo Tree" }, },
    before = function(_)
      vim.g.undotree_WindowLayout = 1
      vim.g.undotree_SplitWidth = 40
    end,
  },
  {
    "mini.nvim",
    for_cat = 'general.always',
    event = "DeferredUIEnter",
    after = function(plugin)
      require('mini.icons').setup()
      require("mini.icons").mock_nvim_web_devicons()
      require('mini.ai').setup()
      require('mini.comment').setup()
      -- require('mini.indentscope').setup {
      --   draw = {
      --     delay = 50,
      --   },
      --   symbol = '│',
      -- }
      require('mini.surround').setup()
      require('mini.pairs').setup()
      require('mini.git').setup()
      require('mini.diff').setup {
        view = {
          style = 'sign',
          signs = { add = '┃', change = '┃', delete = '┃' },
        },
      }
      require('mini.trailspace').setup()
    end,
  },
  {
    "vim-startuptime",
    for_cat = 'general.extra',
    cmd = { "StartupTime" },
    before = function(_)
      vim.g.startuptime_event_width = 0
      vim.g.startuptime_tries = 10
      vim.g.startuptime_exe_path = nixCats.packageBinPath
    end,
  },
  {
    "which-key.nvim",
    for_cat = 'general.extra',
    event = "DeferredUIEnter",
    after = function (plugin)
      require('which-key').setup({
      })
      require('which-key').add {
        { "<leader><leader>", group = "buffer commands" },
        { "<leader><leader>_", hidden = true },
        { "<leader>c", group = "[c]ode" },
        { "<leader>c_", hidden = true },
        { "<leader>d", group = "[d]ocument" },
        { "<leader>d_", hidden = true },
        { "<leader>g", group = "[g]it" },
        { "<leader>g_", hidden = true },
        { "<leader>m", group = "[m]arkdown" },
        { "<leader>m_", hidden = true },
        { "<leader>r", group = "[r]ename" },
        { "<leader>r_", hidden = true },
        { "<leader>s", group = "[s]earch" },
        { "<leader>s_", hidden = true },
        { "<leader>t", group = "[t]oggles" },
        { "<leader>t_", hidden = true },
        { "<leader>w", group = "[w]orkspace" },
        { "<leader>w_", hidden = true },
      }
    end,
  },
}
