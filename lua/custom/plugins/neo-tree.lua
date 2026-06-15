vim.cmd [[ let g:neo_tree_remove_legacy_commands = 1 ]]
local function gh(repo) return 'https://github.com/' .. repo end

vim.pack.add {
  { src = gh 'nvim-neo-tree/neo-tree.nvim', version = 'v3.x' },
  gh 'nvim-lua/plenary.nvim',
  gh 'nvim-tree/nvim-web-devicons',
  gh 'MunifTanjim/nui.nvim',
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
