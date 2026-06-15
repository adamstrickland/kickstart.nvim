local function gh(repo) return 'https://github.com/' .. repo end

vim.pack.add {
  { src = gh 'kylechui/nvim-surround', version = vim.version.range '*' },
}

require('nvim-surround').setup {}
