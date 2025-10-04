return {
  'ravitemer/mcphub.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  build = 'bundled_build.lua', -- Bundles `mcp-hub` binary along with the neovim plugin
  config = function()
    require('mcphub').setup {
      extensions = {
        avante = {
          make_slash_commands = true, -- make /slash commands from MCP server prompts
        },
      },
      use_bundled_binary = true, -- Use local `mcp-hub` binary
      -- native_servers = {
      --   git = require 'custom.servers.git_server',
      -- },
    }
  end,
}
