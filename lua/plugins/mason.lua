return {
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "tailwindcss",
        "gopls",
        "rust_analyzer",
        "pyright",
        "bashls",
        "html",
        "lua_ls",
        "ts_ls",
        "puppet",
        "yamlls",
        "terraformls",
        "docker_compose_language_service",
        "dockerls",
      },
    },
  },
}
