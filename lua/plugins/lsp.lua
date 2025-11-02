return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- make sure mason installs the server
      servers = {
        yamlls = {
          settings = {
            yaml = {
              format = {
                enable = false,
              },
            },
          },
        },
      },
      function()
        local keys = require("lazyvim.plugins.lsp.keymaps").get()

        keys[#keys + 1] = { "Enter", false }
      end,
    },
  },
}
