return {
  --   "mfussenegger/nvim-jdtls",
  --   config = function()
  --     local jdtls = require("jdtls")
  --     local root_markers = {"gradlew", "mvnw", ".git"}
  --     local root_dir = require("jdtls.setup").find_root(root_markers)
  --
  --     local on_attach = function (client, bufnr)
  --     end
  --
  --     jdtls.start_or_attach({
  --       flags = {
  --         debounce_text_changes = 80,
  --       },
  --       on_attach = on_attach,
  --       root_dir = root_dir,
  --     })
  --   end,
}
