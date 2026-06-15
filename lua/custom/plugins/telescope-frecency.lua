local function gh(repo) return 'https://github.com/' .. repo end

vim.pack.add {
  gh 'nvim-telescope/telescope-frecency.nvim',
  gh 'kkharji/sqlite.lua',
}

local telescope = require 'telescope'
telescope.setup {
  extensions = {
    frecency = {
      auto_validate = false,
      show_scores = true,
      show_unindexed = true,
    },
  },
}

telescope.load_extension 'frecency'
