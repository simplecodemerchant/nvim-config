return {
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "tailwindcss",
        "gopls",
        "rust_analyzer",
        "ts_ls",
        "pyright",
        "bashls",
        "html",
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
