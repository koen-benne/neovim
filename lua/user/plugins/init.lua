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
    "supermaven-nvim",
    for_cat = 'general.extra',
    event = "DeferredUIEnter",
    after = function (plugin)
      require('supermaven-nvim').setup {
        keymaps = {
          accept_suggestion = '<C-C>',
        },
      }
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
    "git-blame.nvim",
    for_cat = 'general.extra',
    cmd = {
      "GitBlameToggle",
      "GitBlameEnable",
      "GitBlameDisable",
      "GitBlameOpenCommitURL",
      "GitBlameCopySHA",
      "GitBlameCopyCommitURL",
      "GitBlameOpenFileUrL",
      "GitBlameCopyFileURL",
    },
    keys = {
      {"gb", "<cmd>GitBlameToggle <CR>", mode = {"n"}, noremap = true, desc = "Enable git blame"},
    },
    before = function (plugin)
      vim.g.gitblame_enabled = 0
      vim.g.gitblame_delay = 50
    end,
    after = function (plugin)
      local hl_cursor_line = vim.api.nvim_get_hl(0, { name = "CursorLine" })
      local hl_comment = vim.api.nvim_get_hl(0, { name = "Comment" })
      local hl_combined = vim.tbl_extend("force", hl_comment, { bg = hl_cursor_line.bg })
      vim.api.nvim_set_hl(0, "CursorLineBlame", hl_combined)
      require('gitblame').setup {
        enabled = true,
        highlight_group = "CursorLineBlame",
      }
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
