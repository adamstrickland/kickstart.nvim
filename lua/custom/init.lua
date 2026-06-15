
vim.g.have_been_setup = true

vim.notify = function(msg, log_level, _)
  if msg:match 'which%-key' then
    -- ignore
    return
  end
  vim.api.nvim_echo({ { msg } }, true, {})
end

require 'custom.options'
require 'custom.filetypes'
require 'custom.plugins'
require 'custom.keymaps'
