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
      { 'filename' }, -- Show file name in the status line
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
  { import = "user.plugins.treesitter", dep_of = 'codecompanion.nvim', },
  { import = "user.plugins.completion", },
  { import = "user.plugins.ufo", },
  {
    "promise-async",
    for_cat = 'general.always',
    dep_of = 'nvim-ufo',
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
    dep_of = 'lze',
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
      local diff = require('mini.diff')
      diff.setup {
        view = {
          style = 'sign',
          signs = { add = '┃', change = '┃', delete = '┃' },
        },
        source = diff.gen_source.none(),
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
  {
    "codecompanion.nvim",
    for_cat = 'general.extra',
    event = "DeferredUIEnter", -- We can probably set it to load when running a certain command
    keys = {
      { "<C-a>", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, noremap = true, silent = true, desc = "CodeCompanion Actions" },
      { "<leader>cc", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, noremap = true, silent = true, desc = "Toggle CodeCompanion Chat" },
      { "ga", "<cmd>CodeCompanionChat Add<cr>", mode = { "v" }, noremap = true, silent = true, desc = "Add to CodeCompanion Chat" },
    },
    after = function (plugin)
      -- Create a module-level variable to cache the API key
      local cached_api_key = nil

      local function get_api_key()
        if cached_api_key == nil then
          -- Only call op read if the key hasn't been cached yet
          local handle = io.popen("op read op://Private/Bonzai/credential --no-newline")
          if handle then
            cached_api_key = handle:read("*a")
            handle:close()
          end
        end
        return cached_api_key
      end

      require('codecompanion').setup {
        strategies = {
          chat = {
            adapter = "bonzai",
            keymaps = {
              send = {
                modes = { n = "<CR>", i = "<M-s>" },
              },
            },
          },
          inline = {
            adapter = "bonzai",
          },
          cmd = {
            adapter = "bonzai",
          }
        },
        display = {
          diff = {
            provider = "mini_diff",
          },
        },
        adapters = {
          bonzai = function()
            local openai_adapter = require("codecompanion.adapters").extend("openai", {});
            return require("codecompanion.adapters").extend("openai_compatible", {
            name = "bonzai",
            formatted_name = "Bonzai",
            env = {
              url = "https://api.bonzai.iodigital.com",
              chat_url = "/universal/chat/completions",
              -- Use a function instead of a command
              api_key = get_api_key,
            },
            headers = {
              ["Content-Type"] = "application/json",
              ["api-key"] = "${api_key}",
            },
            schema = {
              model = {
                order = 1,
                mapping = "parameters",
                type = "enum",
                desc = "ID of the model to use.",
                default = "gpt-4o",
                choices = {
                  "gpt-4o",
                  "gpt-4o-mini",
                  ["o3-mini"] = { opts = { can_reason = true } },
                  ["o1"] = { opts = { stream = false } },
                  ["o1-preview"] = { opts = { stream = true } },
                  "claude-3-haiku",
                  "claude-3-5-sonnet",
                  ["claude-3-7-sonnet"] = { opts = { can_reason = true } },
                },
              },
              reasoning_effort = vim.deepcopy(openai_adapter.schema.reasoning_effort),
              temperature = vim.deepcopy(openai_adapter.schema.temperature),
              top_p = vim.deepcopy(openai_adapter.schema.top_p),
              stop = vim.deepcopy(openai_adapter.schema.stop),
              presence_penalty = vim.deepcopy(openai_adapter.schema.presence_penalty),
              frequency_penalty = vim.deepcopy(openai_adapter.schema.frequency_penalty),
            },
          })
          end,
        },
      }
    end,
  }
}
