vim.pack.add { 'https://github.com/klen/nvim-config-local' }

require('config-local').setup {
  autocommands_create = true,
  commands_create = true,
  config_files = { '.nvim.lua', '.nvimrc' },
  hashfile = vim.fn.stdpath 'data' .. '/config-local',
  lookup_parents = false,
  silent = false,
}
