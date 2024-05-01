return {
  "nvim-telescope/telescope-frecency.nvim",
  config = function()
    local telescope = require("telescope")

    telescope.setup({
      extensions = {
        frecency = {
          auto_validate = false,
          show_scores = true,
          show_unindexed = true,
        },
      },
    })

    telescope.load_extension("frecency")
  end,
  dependencies = { "kkharji/sqlite.lua" },
}
