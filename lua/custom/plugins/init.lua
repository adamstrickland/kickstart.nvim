local modules = {
  -- 'kickstart.plugins.debug',
  'kickstart.plugins.indent_line',
  'kickstart.plugins.lint',
  -- 'kickstart.plugins.autopairs',
  -- 'kickstart.plugins.neo-tree',
  'kickstart.plugins.gitsigns', -- adds gitsigns recommended keymaps
}
for _, module in ipairs(modules) do
  local ok, err = pcall(require, module)
  if not ok then vim.notify(('Failed to load plugin module %s: %s'):format(module, err), vim.log.levels.ERROR) end
end

local plugins_dir = vim.fs.joinpath(vim.fn.stdpath 'config', 'lua', 'custom', 'plugins')
local custom_files = {}
for file_name, file_type in vim.fs.dir(plugins_dir, { follow = true }) do
  if (file_type == 'file' or file_type == 'link') and file_name:match '%.lua$' and file_name ~= 'init.lua' then
    custom_files[#custom_files + 1] = file_name
  end
end

table.sort(custom_files)
for _, file_name in ipairs(custom_files) do
  local file_path = vim.fs.joinpath(plugins_dir, file_name)
  local ok, err = pcall(dofile, file_path)
  if not ok then vim.notify(('Failed to load plugin file %s: %s'):format(file_name, err), vim.log.levels.ERROR) end
end
