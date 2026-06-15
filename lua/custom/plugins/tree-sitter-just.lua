local function gh(repo) return 'https://github.com/' .. repo end

vim.pack.add { gh 'IndianBoy42/tree-sitter-just' }
local ok_parsers, parsers = pcall(require, 'nvim-treesitter.parsers')
if ok_parsers and type(parsers.get_parser_configs) == 'function' then
  local ok_just, tree_sitter_just = pcall(require, 'tree-sitter-just')
  if ok_just then
    local ok_setup, err = pcall(tree_sitter_just.setup, {})
    if not ok_setup then vim.notify(('Failed to initialize tree-sitter-just: %s'):format(err), vim.log.levels.WARN) end
  end
end
