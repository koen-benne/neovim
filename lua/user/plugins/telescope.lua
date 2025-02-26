local function find_git_root()
  -- Use the current buffer's path as the starting point for the git search
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir
  local cwd = vim.fn.getcwd()
  -- If the buffer is not associated with a file, return nil
  if current_file == "" then
    current_dir = cwd
  else
    -- Extract the directory from the current file's path
    current_dir = vim.fn.fnamemodify(current_file, ":h")
  end

  -- Find the Git root directory from the current file's path
  local git_root = vim.fn.systemlist("git -C " .. vim.fn.escape(current_dir, " ") .. " rev-parse --show-toplevel")[1]
  if vim.v.shell_error ~= 0 then
    print("Not a git repository. Searching on current working directory")
    return cwd
  end
  return git_root
end

-- Custom live_grep function to search in git root
local function live_grep_git_root()
  local git_root = find_git_root()
  if git_root then
    require('telescope.builtin').live_grep({
      search_dirs = { git_root },
    })
  end
end

return {
  {
    "telescope.nvim",
    for_cat = 'general.telescope',
    cmd = { "Telescope", "LiveGrepGitRoot" },
    -- NOTE: our on attach function defines keybinds that call telescope.
    -- so, the on_require handler will load telescope when we use those.
    on_require = { "telescope", },
    -- event = "",
    -- ft = "",
    keys = {
      { "<leader>ss", function() return require('telescope.builtin').builtin() end, mode = {"n"}, desc = '[S]earch [S]elect Telescope', },
      { "<leader>s.", function() return require('telescope.builtin').oldfiles() end, mode = {"n"}, desc = '[S]earch Recent Files ("." for repeat)', },
      { ";", function() return require('telescope.builtin').buffers() end, mode = {"n"}, desc = '[ ] Find existing buffers', },
      { "<leader>/", function()
        require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, mode = {"n"}, desc = '[/] Fuzzily search in current buffer', },
      { "<leader>sf", function() return require('telescope.builtin').find_files() end, mode = {"n"}, desc = '[S]earch [F]iles', },
      { "<leader>rg", function() return require('telescope.builtin').live_grep() end, mode = {"n"}, desc = 'Search by [R]ip[G]rep', },
      { "<leader>sM", '<cmd>Telescope notify<CR>', mode = {"n"}, desc = '[S]earch [M]essage', },
      { "<leader>sp",live_grep_git_root, mode = {"n"}, desc = '[S]earch git [P]roject root', },
      { "<leader>s/", function()
        require('telescope.builtin').live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, mode = {"n"}, desc = '[S]earch [/] in Open Files' },
      { "<leader>sr", function() return require('telescope.builtin').resume() end, mode = {"n"}, desc = '[S]earch [R]esume', },
      { "<leader>sd", function() return require('telescope.builtin').diagnostics() end, mode = {"n"}, desc = '[S]earch [D]iagnostics', },
      { "<leader>sw", function() return require('telescope.builtin').grep_string() end, mode = {"n"}, desc = '[S]earch current [W]ord', },
      { "<leader>sk", function() return require('telescope.builtin').keymaps() end, mode = {"n"}, desc = '[S]earch [K]eymaps', },
      { "<leader>sh", function() return require('telescope.builtin').help_tags() end, mode = {"n"}, desc = '[S]earch [H]elp', },
    },
    -- colorscheme = "",
    load = function (name)
        vim.cmd.packadd(name)
        vim.cmd.packadd("telescope-fzy-native.nvim")
        vim.cmd.packadd("telescope-ui-select.nvim")
        vim.cmd.packadd("telescope-media-files.nvim")
        vim.cmd.packadd("telescope-file-browser.nvim")
        vim.cmd.packadd("telescope-undo.nvim")
    end,
    after = function (plugin)
      local telescope = require('telescope')
      local icons = require('utils.icons')

      telescope.setup {
        defaults = {
          winblend = 10,

          vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
          },
          prompt_prefix = icons.ui.Search .. ' ',
          selection_caret = '  ',
          path_display = { 'smart' },
          initial_mode = 'insert',
          election_strategy = 'reset',
          sorting_strategy = 'ascending',
          layout_strategy = 'horizontal',
          file_ignore_patterns = { 'node_modules' },
          border = {},
          borderchars = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
          set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
          color_devicons = true,
          layout_config = {
            horizontal = {
              prompt_position = 'top',
              preview_width = 0.55,
              results_width = 0.8,
            },
            vertical = {
              mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
        },

        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
          media_files = {
            -- filetypes whitelist
            filetypes = { 'png', 'webp', 'jpg', 'jpeg', 'mp4', 'webm', 'pdf', 'mkv' },
            find_cmd = 'fd',
          },
          file_browser = {
            mappings = {
              ['i'] = {
                -- your custom insert mode mappings
              },
              ['n'] = {
                -- your custom normal mode mappings
              },
            },
          },
        },
      }

      telescope.load_extension('media_files')
      telescope.load_extension('file_browser')
      telescope.load_extension('projects')
      telescope.load_extension('undo')

      -- Telescope colors
      local highlight = require('utils.highlights')

      highlight.fg_bg('TelescopeBorder', '#16161d', '#16161d')
      highlight.fg_bg('TelescopePromptBorder', '#1a1b26', '#1a1b26')

      highlight.fg_bg('TelescopePromptNormal', '#fff', '#1a1b26')
      highlight.fg_bg('TelescopePromptPrefix', '#957fb8', '#b1a1b26')

      highlight.bg('TelescopeNormal', '#16161d')
      highlight.bg('TelescopeMatching', '#b1a1b26')
      highlight.bg('TelescopeSelectionCaret', '#957fb8')
      highlight.bg('TelescopeSelection', '#b1a1b26')
      highlight.bg('TelescopeMultiSelection', '#b1a1b26')

      highlight.fg_bg('TelescopePreviewTitle', '#000000', '#7e9cd8')
      highlight.fg_bg('TelescopePromptTitle', '#000000', '#957fb8')
      highlight.fg_bg('TelescopeResultsTitle', '#16161d', '#16161d')

      highlight.bg('TelescopeSelection', '#3b323e')

      vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})
    end,
  },
}
