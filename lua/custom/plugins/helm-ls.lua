-- Unless you are still migrating, remove the deprecated commands from v1.x
-- vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

return {
  "mrjosh/helm-ls",
  version = "*",
  dependencies = {
    "towolf/vim-helm",
  },
  config = function ()
    local configs = require('lspconfig.configs')
    local lspconfig = require('lspconfig')
    local util = require('lspconfig.util')

    if not configs.helm_ls then
      configs.helm_ls = {
        default_config = {
          cmd = {"helm_ls", "serve"},
          filetypes = {'helm'},
          root_dir = function(fname)
            return util.root_pattern('Chart.yaml')(fname)
          end,
        },
      }
    end

    lspconfig.helm_ls.setup {
      filetypes = {"helm"},
      cmd = {"helm_ls", "serve"},
    }
  end,
}

