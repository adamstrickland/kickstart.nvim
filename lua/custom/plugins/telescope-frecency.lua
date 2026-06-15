vim.pack.add {
  'https://github.com/nvim-telescope/telescope-frecency.nvim',
  'https://github.com/kkharji/sqlite.lua',
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
