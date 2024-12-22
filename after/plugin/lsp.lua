local lsp_zero = require('lsp-zero')

local lsp_attach = function(client, bufnr)
  local opts = { buffer = bufnr }

  vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
  vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
  vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
  vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
  vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
  vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
  vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
  vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
  vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
  vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
end

lsp_zero.extend_lspconfig({
  sign_text = true,
  lsp_attach = lsp_attach,
  float_border = 'rounded',
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
})

lsp_zero.format_on_save({
  format_opts = {
    async = false,
    timeout_ms = 10000,
  },
  servers = {
    ['ts_ls'] = { 'javascript', 'typescript' },
    ['lua_ls'] = { 'lua' },
    ['pyright'] = { 'python' },
    ['html'] = { 'html' },
    ['gopls'] = { 'go' },
    ['goimports'] = { 'go' },
    ["svelte"] = { "svelte" },
    ["terraformls"] = { "terraform", "terraform-vars" },
    ["solargraph"] = { "ruby" },

  }
})

--local servers = {
--  terraformls = {
--    filetype = { 'tf', "terraform", "terraform-vars" }
--  }
--}
local util = require("lspconfig/util")

require('mason').setup({})
require('mason-lspconfig').setup({
  -- Replace the language servers listed here
  -- with the ones you want to install
  ensure_installed = {
    'rust_analyzer',
    'tailwindcss',
    'gopls',
    'ts_ls',
    'pyright',
    'bashls',
    'html',
    'lua_ls',
    'puppet',
    'yamlls',
    'terraformls',
    'docker_compose_language_service',
    'dockerls',
  },
  handlers = {
    function(server_name)
      require('lspconfig')[server_name].setup({
        --        filetypes = (servers[server_name] or {}).filetype
      })
    end,

    lua_ls = function()
      local lua_opts = lsp_zero.nvim_lua_ls()
      require("lspconfig").lua_ls.setup(lua_opts)
    end,

    rust_analyzer = function()
      require("lspconfig").rust_analyzer.setup({
        filetype = { "rust" },
        root_dir = util.root_pattern("Cargo.toml"),
        settings = {
          ['rust-analyzer'] = {
            cargo = {
              allFeatures = true,
            },
          },
        },
        on_attach = function(client, bufnr)
          vim.lsp.inlay_hint.enable(true)
        end
      })
    end
  },
})

local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()
local cmp_format = require('lsp-zero').cmp_format({ details = true })

cmp.setup({
  preselect = 'item',
  completion = {
    completeopt = 'menu,menuone,noinsert'
  },
  sources = {
    { name = 'path' },
    { name = 'nvim_lsp' },
    { name = 'luasnip', keyword_length = 2 },
    { name = 'buffer',  keyword_length = 3 },
    { name = "crates" },
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  snippet = {
    expand = function(args)
      -- You need Neovim v0.10 to use vim.snippet
      require('luasnip').lsp_expand(args.body)
    end,
  },
  formatting = cmp_format,
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-CR>'] = cmp.mapping.confirm({ select = false }),
    ['<C-f>'] = cmp_action.luasnip_jump_forward(),
    ['<C-b>'] = cmp_action.luasnip_jump_backward(),
  }),
})
