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
    return ' @' .. reg_recording
  end
  -- executing macros
  local reg_executing = vim.fn.reg_executing()
  if reg_executing ~= '' then
    return ' @' .. reg_executing
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
      { "<C-a>", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "CodeCompanion Actions" },
      { "<leader>cc", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "Toggle CodeCompanion Chat" },
      { "ga", "<cmd>CodeCompanionChat Add<cr>", mode = { "v" }, desc = "Add to CodeCompanion Chat" },
    },
    after = function (plugin)
      -- Create a module-level variable to cache the API key
      local cached_api_key = nil

      local function get_api_key()
        if cached_api_key == nil then
          -- Only call op read if the key hasn't been cached yet
          local handle = io.popen("op read op://Private/Bonzai/credential --no-newline 2>/dev/null")
          if handle then
            cached_api_key = handle:read("*a")
            handle:close()
            -- Validate the key isn't empty
            if cached_api_key == "" or cached_api_key == nil then
              vim.notify("Failed to retrieve API key from 1Password", vim.log.levels.ERROR)
              cached_api_key = nil
            end
          else
            vim.notify("Failed to execute 1Password CLI", vim.log.levels.ERROR)
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
          },
        },
        adapters = {
          http = {
            bonzai = function()
              return require("codecompanion.adapters.http").extend("openai_compatible", {
                name = "bonzai",
                formatted_name = "Bonzai",
                env = {
                  url = "https://api-v2.bonzai.iodigital.com",
                  chat_url = "/v1/chat/completions",
                  api_key = get_api_key,
                },
                headers = {
                  ["Content-Type"] = "application/json",
                  ["Authorization"] = "Bearer ${api_key}",
                },
                parameters = {
                  stream = true,
                  max_tokens = 4096,
                  temperature = 0.1,
                },
                schema = {
                  model = {
                    mapping = "parameters",
                    type = "enum",
                    desc = "ID of the model to use.",
                    default = "claude-3-7-sonnet",
                    choices = {
                      -- OpenAI Models
                      "gpt-4o",
                      "gpt-4.1",
                      "gpt-4o-mini",
                      "gpt-4.1-mini",
                      "gpt-4.1-nano",
                      "gpt-5",
                      "gpt-5-mini",
                      "gpt-5-nano",

                      -- Reasoning Models (o-series)
                      ["o1"] = { opts = { stream = false, can_reason = true } },
                      ["o3"] = { opts = { stream = false, can_reason = true } },
                      ["o3-mini"] = { opts = { stream = false, can_reason = true } },
                      ["o4-mini"] = { opts = { stream = false, can_reason = true } },

                      -- Claude Models (Anthropic)
                      "claude-3-haiku",
                      "claude-3-5-sonnet",
                      "claude-3-7-sonnet",      -- Latest with advanced reasoning
                      "claude-4-sonnet",
                      "claude-4-5-sonnet",

                      -- Vertex AI versions
                      "claude-3-haiku-vertex",
                      "claude-3-5-sonnet-vertex",
                      "claude-3-7-sonnet-vertex",
                      "claude-4-sonnet-vertex",
                      "claude-4-5-sonnet-vertex",

                      -- Google Models
                      "gemini-2.5-flash",
                      "gemini-2.5-pro",

                      -- Coding Specialist
                      "codestral-latest",
                    },
                  },
                  max_tokens = {
                    order = 2,
                    mapping = "parameters",
                    type = "number",
                    optional = true,
                    default = 4096,
                    desc = "Maximum tokens for completion",
                  },
                  temperature = {
                    order = 2,
                    mapping = "parameters",
                    type = "number",
                    optional = true,
                    default = 0.1,
                    desc = "Temperature for response randomness (0.0-2.0)",
                  },
                  top_p = {
                    order = 4,
                    mapping = "parameters",
                    type = "number",
                    optional = true,
                    default = 1.0,
                    desc = "Top-p for nucleus sampling (0.0-1.0)",
                  },
                  stream = {
                    order = 5,
                    mapping = "parameters",
                    type = "boolean",
                    optional = true,
                    default = true,
                    desc = "Stream the response",
                  },
                },
              })
            end,
            opts = {
              log_level = "ERROR",
              send_code = true,
              use_default_actions = true,
            },
          },
        },
      }
    end,
  }
}

