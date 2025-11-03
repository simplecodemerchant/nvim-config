return {
  { "mason-org/mason.nvim", version = "^2.0.0" },
  {
    "mason-org/mason-lspconfig.nvim",
    version = "^2.0.0",
    opts = {
      ensure_installed = {
        "bashls",
        "lua_ls",
        "puppet",
        "yamlls",
        "terraformls",
        "docker_compose_language_service",
        "dockerls",
      },
    },
  },
}
