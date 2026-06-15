local function gh(repo) return 'https://github.com/' .. repo end

vim.pack.add {
  gh 'MeanderingProgrammer/render-markdown.nvim',
  gh 'nvim-treesitter/nvim-treesitter',
  gh 'nvim-tree/nvim-web-devicons',
}

require('render-markdown').setup {
  file_types = { 'markdown', 'Avante' },
}
