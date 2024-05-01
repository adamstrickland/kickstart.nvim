return {
  "folke/tokyonight.nvim",
  config = function()
    require("tokyonight").setup({
      -- style = "day",
      dim_inactive = true,
    })
    -- vim.cmd.colorscheme 'tokyonight'
  end,
}
