-- require 'custom.plugins'

-- require('lazy').setup {
--   { import = 'custom.plugins' },
-- }

vim.g.have_been_setup = true

vim.notify = function(msg, log_level, _)
  if msg:match 'which%-key' then
    -- ignore
    return
  end
  vim.api.nvim_echo({ { msg } }, true, {})
end

require 'custom.keymaps'
require 'custom.options'
require 'custom.filetypes'
