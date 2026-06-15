local function gh(repo) return 'https://github.com/' .. repo end

vim.pack.add {
  { src = gh 'mrjosh/helm-ls', version = vim.version.range '*' },
  gh 'towolf/vim-helm',
}

local configs = require 'lspconfig.configs'
local lspconfig = require 'lspconfig'
local util = require 'lspconfig.util'

if not configs.helm_ls then
  configs.helm_ls = {
    default_config = {
      cmd = { 'helm_ls', 'serve' },
      filetypes = { 'helm' },
      root_dir = function(fname) return util.root_pattern('Chart.yaml')(fname) end,
    },
  }
end

lspconfig.helm_ls.setup {
  filetypes = { 'helm' },
  cmd = { 'helm_ls', 'serve' },
}

