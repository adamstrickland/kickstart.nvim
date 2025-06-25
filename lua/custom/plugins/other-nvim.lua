return {
  'rgroli/other.nvim',
  config = function()
    require('other-nvim').setup {
      mappings = {
        'rails',
        'golang',
        'python',
        'react',
        'rust',
      },
    }

    vim.api.nvim_set_keymap('n', '<leader>of', '<cmd>:Other<CR>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<leader>o-', '<cmd>:OtherSplit<CR>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<leader>o|', '<cmd>:OtherVSplit<CR>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<leader>oc', '<cmd>:OtherClear<CR>', { noremap = true, silent = true })

    -- Context specific bindings
    -- vim.api.nvim_set_keymap("n", "<leader>lt", "<cmd>:Other test<CR>", { noremap = true, silent = true })
    -- vim.api.nvim_set_keymap("n", "<leader>ls", "<cmd>:Other scss<CR>", { noremap = true, silent = true })
  end,
}
