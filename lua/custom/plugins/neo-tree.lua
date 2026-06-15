vim.cmd [[ let g:neo_tree_remove_legacy_commands = 1 ]]
vim.pack.add {
  { src = 'https://github.com/nvim-neo-tree/neo-tree.nvim', version = 'v3.x' },
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/nvim-tree/nvim-web-devicons',
  'https://github.com/MunifTanjim/nui.nvim',
}

require('neo-tree').setup {
  filesystem = {
    filtered_items = {
      hide_by_name = {
        'node_modules',
      },
      hide_dotfiles = false,
      hide_gitignored = false,
      never_show = {
        '__pycache__',
        '.DS_Store',
        'thumbs.db',
        '.terraform',
        '.terraform.lock.hcl',
        'terraform.tfstate',
        'terraform.tfstate.backup',
      },
    },
    follow_current_file = {
      enabled = false,
    },
  },
}

vim.keymap.set('n', '<leader>e', '<CMD>Neotree toggle<CR>', { desc = 'Toggle Neotree' })
