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
        tofu_ls = {},
      },
      function()
        local keys = require("lazyvim.plugins.lsp.keymaps").get()

        keys[#keys + 1] = { "Enter", false }
      end,
    },
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.terraform = { "tofu_fmt" }
      opts.formatters_by_ft.tf = { "tofu_fmt" }
      opts.formatters_by_ft.hcl = { "tofu_fmt" }

      opts.formatters = opts.formatters or {}
      opts.formatters.tofu_fmt = {
        command = "tofu",
        args = { "fmt", "-" },
      }
    end,
  },
}
