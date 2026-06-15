local function gh(repo) return 'https://github.com/' .. repo end

vim.pack.add { gh 'folke/tokyonight.nvim' }

require('tokyonight').setup {
  -- style = 'day',
  dim_inactive = true,
}

-- vim.cmd.colorscheme 'tokyonight'
