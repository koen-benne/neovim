return {
  {
    "oil.nvim",
    for_cat = 'general.always',
    cmd = "Oil",
    keys = {
      { "-", "<cmd>Oil<CR>", mode = { "n" }, desc = "Open parent directory" },
    },
    after = function(plugin)
      require('oil').setup({
        default_file_explorer = true,
        columns = {
          "icon",
        },
        delete_to_trash = true,
        skip_confirm_for_simple_edits = true,
        git = {
          add = function(path)
            return vim.fn.system({ "git", "add", "--", path })
          end,
          mv = function(src_path, dest_path)
            return vim.fn.system({ "git", "mv", "--", src_path, dest_path })
          end,
          rm = function(path)
            return vim.fn.system({ "git", "rm", "--", path })
          end,
        },
        lsp_file_methods = {
          enabled = true,
          timeout_ms = 1000,
          autosave_changes = true,
        },
        watch_for_changes = true,
        view_options = {
          show_hidden = false,
          is_hidden_file = function(name, bufnr)
            return vim.startswith(name, ".")
          end,
        },
        keymaps = {
          ["g?"] = "actions.show_help",
          ["<CR>"] = "actions.select",
          ["<C-v>"] = { "actions.select", opts = { vertical = true }, desc = "Open in vertical split" },
          ["<C-s>"] = { "actions.select", opts = { horizontal = true }, desc = "Open in horizontal split" },
          ["<C-t>"] = { "actions.select", opts = { tab = true }, desc = "Open in new tab" },
          ["<C-p>"] = "actions.preview",
          ["<C-c>"] = "actions.close",
          ["<C-l>"] = "actions.refresh",
          ["-"] = "actions.parent",
          ["_"] = "actions.open_cwd",
          ["`"] = "actions.cd",
          ["~"] = { "actions.cd", opts = { scope = "tab" }, desc = ":tcd to the current oil directory" },
          ["gs"] = "actions.change_sort",
          ["gx"] = "actions.open_external",
          ["g."] = "actions.toggle_hidden",
          ["g\\"] = "actions.toggle_trash",
        },
        use_default_keymaps = false,
      })
    end,
  },
  {
    "oil-git-status.nvim",
    for_cat = 'general.always',
    dep_of = 'oil.nvim',
  },
}
