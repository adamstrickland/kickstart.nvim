local function gh(repo) return 'https://github.com/' .. repo end

vim.pack.add {
  gh 'yetone/avante.nvim',
  gh 'nvim-treesitter/nvim-treesitter',
  gh 'stevearc/dressing.nvim',
  gh 'nvim-lua/plenary.nvim',
  gh 'MunifTanjim/nui.nvim',
  gh 'echasnovski/mini.pick',
  gh 'nvim-telescope/telescope.nvim',
  gh 'hrsh7th/nvim-cmp',
  gh 'ibhagwan/fzf-lua',
  gh 'nvim-tree/nvim-web-devicons',
  gh 'HakonHarnes/img-clip.nvim',
  gh 'MeanderingProgrammer/render-markdown.nvim',
}
vim.api.nvim_create_autocmd('PackChanged', {
  group = vim.api.nvim_create_augroup('custom-avante-build', { clear = true }),
  callback = function(ev)
    local data = ev.data
    if not data or not data.spec or data.spec.name ~= 'avante.nvim' then return end
    if data.kind ~= 'install' and data.kind ~= 'update' then return end
    if vim.fn.executable 'make' ~= 1 then return end

    local result = vim.system({ 'make' }, { cwd = data.path }):wait()
    if result.code ~= 0 then
      local stderr = result.stderr or ''
      local stdout = result.stdout or ''
      local output = stderr ~= '' and stderr or stdout
      if output == '' then output = 'No output from build command.' end
      vim.notify(('Build failed for avante.nvim:\n%s'):format(output), vim.log.levels.ERROR)
    end
  end,
})

local ok_img_clip, img_clip = pcall(require, 'img-clip')
if ok_img_clip then
  img_clip.setup {
    default = {
      embed_image_as_base64 = false,
      prompt_for_file_name = false,
      drag_and_drop = {
        insert_mode = true,
      },
      use_absolute_path = true,
    },
  }
end

require('avante').setup {
  behaviour = {
    -- enable_cursor_planning_mode = true, -- enable cursor planning mode!
  },
  provider = 'claude',
  providers = {
    claude = {
      endpoint = 'https://api.anthropic.com',
      model = 'claude-sonnet-4-20250514',
      timeout = 30000,
      disable_tools = true,
      extra_request_body = {
        temperature = 0.75,
        max_tokens = 20480,
      },
    },
    claude_sonnet_with_tools = {
      __inherited_from = 'claude',
      disable_tools = false,
    },
    claude_opus = {
      __inherited_from = 'claude',
      model = 'claude-opus-4-20250514',
    },
  },
  custom_tools = function()
    local ok_mcphub, avante_ext = pcall(require, 'mcphub.extensions.avante')
    if not ok_mcphub then return {} end
    return { avante_ext.mcp_tool() }
  end,
}
