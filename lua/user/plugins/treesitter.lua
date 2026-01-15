-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
return {
  {
    "nvim-treesitter",
    for_cat = 'general.treesitter',
    event = "DeferredUIEnter",
    load = function(name)
      vim.cmd.packadd(name)
    end,
    after = function (plugin)
      -- Load dependent plugins AFTER nvim-treesitter is loaded
      vim.cmd.packadd("nvim-treesitter-context")
      vim.cmd.packadd("nvim-treesitter-textobjects")
      vim.cmd.packadd("nvim-ts-context-commentstring")

      vim.g.skip_ts_context_comment_string_module = true

      -- nvim-treesitter v0.10+ uses a simplified API
      -- Syntax highlighting is now enabled by default in Neovim
      vim.treesitter.language.register('bash', 'sh')

      -- Configure textobjects separately (now standalone)
      require('nvim-treesitter-textobjects').setup {
        select = {
          enable = true,
          lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ['aa'] = '@parameter.outer',
            ['ia'] = '@parameter.inner',
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            [']m'] = '@function.outer',
            [']]'] = '@class.outer',
          },
          goto_next_end = {
            [']M'] = '@function.outer',
            [']['] = '@class.outer',
          },
          goto_previous_start = {
            ['[m'] = '@function.outer',
            ['[['] = '@class.outer',
          },
          goto_previous_end = {
            ['[M'] = '@function.outer',
            ['[]'] = '@class.outer',
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ['<leader>a'] = '@parameter.inner',
          },
          swap_previous = {
            ['<leader>A'] = '@parameter.inner',
          },
        },
      }

      -- Incremental selection (built into Neovim treesitter now)
      vim.keymap.set('n', '<c-space>', function()
        vim.cmd('normal! v')
        require('vim.treesitter').select_range()
      end, { desc = 'Treesitter: Init selection' })
      vim.keymap.set('x', '<c-space>', function()
        require('vim.treesitter').select_range()
      end, { desc = 'Treesitter: Expand selection' })
      vim.keymap.set('x', '<M-space>', function()
        require('vim.treesitter').select_range({ parent = true })
      end, { desc = 'Treesitter: Shrink selection' })

      require('treesitter-context').setup {
        max_lines = 3,
      }

      require('ts_context_commentstring').setup()

      -- Tree-sitter based folding
      -- vim.opt.foldmethod = 'expr'
      vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
    end,
  },
}
