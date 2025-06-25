vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Open diagnostics' })
vim.keymap.set('n', '<C-w>-', ':split<CR>', { desc = 'Split window (horizontal)' })
vim.keymap.set('n', '<C-w><bar>', ':vsplit<CR>', { desc = 'Split window (vertical)' })
vim.keymap.set('n', '<leader>Ci', ':e ~/.config/nvim/init.lua<CR>', { desc = 'Edit init.lua' })
vim.keymap.set('n', '<leader>Ck', ':e ~/.config/nvim/lua/custom/keymaps.lua<CR>', { desc = 'Edit custom/keymaps.lua' })
vim.keymap.set('n', '<leader>Co', ':e ~/.config/nvim/lua/custom/options.lua<CR>', { desc = 'Edit custom/options.lua' })
vim.keymap.set('n', '<leader>Cp', ':e ~/.config/nvim/lua/custom/plugins<CR>', { desc = 'Edit custom/plugins' })
vim.keymap.set('n', '<leader>f', '<CMD>Telescope frecency theme=dropdown<CR>', { desc = 'Display buffers by frecency' })
vim.keymap.set('n', '<leader>gl', '<CMD>FloatermNew! --cwd=<root> --disposable lazygit<CR>', { desc = 'Show lazygit' })
vim.keymap.set('n', '<leader>tt', '<CMD>FloatermToggle<CR>', { desc = 'Toggle floaterm' })
vim.keymap.set('n', '<leader>x', ':s/\\-\\s\\[\\s*\\]/- [x]/<CR>', { desc = 'Mark task as done' })

Open_Alternate_File = function()
  local path = vim.api.nvim_buf_get_name(0)
  local _, _, dir_path, file_name, file_ext = string.find(path, '^(.+/)([^/]+)(%..*)$')
  local start, _ = string.find(file_name, '_?test_?')
  local alt_file_name = start == nil and file_name .. '_test' or string.gsub(file_name, '_?test_?', '')
  local alt_path = dir_path .. alt_file_name .. file_ext

  vim.api.nvim_command('edit ' .. alt_path)
end

vim.keymap.set('n', '<leader>A', '<CMD>lua Open_Alternate_File()<CR>', { desc = 'Open alternate file' })

-- local function filetype_autocmd(ft, callback)
--   vim.api.nvim_create_autocmd('FileType', {
--     pattern = ft,
--     callback = callback,
--   })
-- end
--
-- local function run_file(key, cmd_template, split_cmd)
--   local cmd = cmd_template:gsub('%%', vim.fn.expand '%:p')
--   buf_map(0, 'n', key, function()
--     vim.cmd(split_cmd)
--     vim.cmd('terminal ' .. cmd)
--   end)
-- end

Mods_Cmd = function(options)
  local base = 'cat % | $(go env GOPATH)/bin/mdembed | $(go env GOPATH)/bin/mods ' .. options
  local cmd = base:gsub('%%', vim.fn.expand '%:p')
  return cmd
end
Mods_Split = function(options)
  vim.cmd 'split'
  vim.cmd('terminal' .. ' ' .. Mods_Cmd(options))
end
Mods_VSplit = function(options)
  vim.cmd 'vsplit'
  vim.cmd('terminal' .. ' ' .. Mods_Cmd(options))
end
vim.keymap.set('n', '<leader>mr', '<CMD>lua Mods_VSplit("")<CR>', { desc = 'Run mods, pipe to VSplit' })
vim.keymap.set('n', '<leader>mR', '<CMD>lua Mods_Split("")<CR>', { desc = 'Run mods, pipe to Split' })
vim.keymap.set('n', '<leader>mc', '<CMD>lua Mods_VSplit("-C")<CR>', { desc = 'Run mods -C, pipe to VSplit' })
vim.keymap.set('n', '<leader>mC', '<CMD>lua Mods_Split("-C")<CR>', { desc = 'Run mods -C, pipe to Split' })

-- vim.keymap.set('n', '<F5>', function()
--   require('dap').continue()
-- end)
vim.keymap.set('n', '<F1>', '<CMD>DapToggleBreakpoint<CR>', { desc = 'Toggle breakpoint' })
vim.keymap.set('n', '<F2>', '<CMD>DapSetBreakpoint<CR>', { desc = 'Set breakpoint' })
vim.keymap.set('n', '<F7>', '<CMD>DapContinue<CR>', { desc = 'Start/continue debugging' })
vim.keymap.set('n', '<F8>', '<CMD>DapStepInto<CR>', { desc = 'Debug: Step Into' })
vim.keymap.set('n', '<F9>', '<CMD>DapStepOver<CR>', { desc = 'Debug: Step Over' })
vim.keymap.set('n', '<F10>', '<CMD>DapStepOut<CR>', { desc = 'Debug: Step Out' })
-- vim.keymap.set('n', '<F10>', function()
--   require('dap').step_over()
-- end)
-- vim.keymap.set('n', '<F11>', function()
--   require('dap').step_into()
-- end)
-- vim.keymap.set('n', '<F12>', function()
--   require('dap').step_out()
-- end)
-- -- vim.keymap.set('n', '<Leader>b', function() require('dap').toggle_breakpoint() end)
-- -- vim.keymap.set('n', '<Leader>B', function() require('dap').set_breakpoint() end)
-- vim.keymap.set('n', '<Leader>lp', function()
--   require('dap').set_breakpoint(nil, nil, vim.fn.input 'Log point message: ')
-- end)
-- vim.keymap.set('n', '<Leader>dr', function()
--   require('dap').repl.open()
-- end)
-- vim.keymap.set('n', '<Leader>dl', function()
--   require('dap').run_last()
-- end)
-- vim.keymap.set({ 'n', 'v' }, '<Leader>dh', function()
--   require('dap.ui.widgets').hover()
-- end)
-- vim.keymap.set({ 'n', 'v' }, '<Leader>dp', function()
--   require('dap.ui.widgets').preview()
-- end)
-- vim.keymap.set('n', '<Leader>df', function()
--   local widgets = require 'dap.ui.widgets'
--   widgets.centered_float(widgets.frames)
-- end)
-- vim.keymap.set('n', '<Leader>dc', function()
--   local widgets = require 'dap.ui.widgets'
--   widgets.centered_float(widgets.scopes)
-- end)
