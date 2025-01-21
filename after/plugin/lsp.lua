-- note: diagnostics are not exclusive to lsp servers
-- so these can be global keybindings
vim.keymap.set('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')
vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')


vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(args)
    local opts = { buffer = args.buf }

    -- these will be buffer-local keybindings
    -- because they only work if you have an active language server

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

    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if client ~= nil then
      if client:supports_method('textDocument/completion') then
        vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = false })
      end
    --
    --   if client:supports_method('textDocument/formatting') then
    --     vim.api.nvim_create_autocmd('BufWritePre', {
    --       buffer = args.buf,
    --       callback = function()
    --         vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
    --       end,
    --     })
    --   end
    --
    --   if client:supports_method('textDocument/inlayHint') then
    --     vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
    --   end
    --
    --   if client:supports_method('textDocument/documentHighlight') then
    --     local autocmd = vim.api.nvim_create_autocmd
    --     local augroup = vim.api.nvim_create_augroup('lsp_highlight', { clear = false })
    --
    --     vim.api.nvim_clear_autocmds({ buffer = args.buf, group = augroup })
    --
    --     autocmd({ 'CursorHold' }, {
    --       group = augroup,
    --       buffer = args.buf,
    --       callback = vim.lsp.buf.document_highlight,
    --     })
    --
    --     autocmd({ 'CursorMoved' }, {
    --       group = augroup,
    --       buffer = args.buf,
    --       callback = vim.lsp.buf.clear_references,
    --     })
    --   end
    end
  end
})

local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {
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
        capabilities = lsp_capabilities,
      })
    end,

    lua_ls = function()
      require('lspconfig').lua_ls.setup({
        capabilities = lsp_capabilities,
        settings = {
          Lua = {
            runtime = {
              version = 'LuaJIT'
            },
            diagnostics = {
              globals = { 'vim' },
            },
            workspace = {
              library = {
                vim.env.VIMRUNTIME,
              }
            }
          }
        }
      })
    end,
  },
})

local cmp = require('cmp')

cmp.setup({
  sources = {
    { name = 'path' },
    { name = 'nvim_lsp' },
    { name = 'luasnip', keyword_length = 2 },
    { name = 'buffer',  keyword_length = 3 },
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
  }),
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,

  },
})

local ls = require('luasnip')
local lstypes = require('luasnip.util.types')

vim.snippet.expand = ls.lsp_expand

---@diagnostic disable-next-line: duplicate-set-field
vim.snippet.active = function(filter)
  filter = filter or {}
  filter.direction = filter.direction or 1

  if filter.direction == 1 then
    return ls.expand_or_jumpable()
  else
    return ls.jumpable(filter.direction)
  end
end

---@diagnostic disable-next-line: duplicate-set-field
vim.snippet.jump = function(direction)
  if direction == 1 then
    if ls.expandable() then
      return ls.expand_or_jump()
    else
      return ls.jumpable(1) and ls.jump(1)
    end
  else
    return ls.jumpable(-1) and ls.jump(-1)
  end
end

vim.snippet.stop = ls.unlink_current

ls.config.set_config {
  history = true,
  update = 'TextChanged,TextChangedI',
  override_builtin = true,
}

for _, ft_path in ipairs(vim.api.nvim_get_runtime_file("snippets/*.lua", true)) do
  loadfile(ft_path)()
end

vim.keymap.set({ "i", "s" }, "<c-k>", function()
  return vim.snippet.active { direction = 1 } and vim.snippet.jump(1)
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<c-j>", function()
  return vim.snippet.active { direction = -1 } and vim.snippet.jump(-1)
end, { silent = true })




--local lsp_zero = require('lsp-zero')
--
--local lsp_attach = function(client, bufnr)
--  local opts = { buffer = bufnr }
--
--  vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
--  vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
--  vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
--  vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
--  vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
--  vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
--  vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
--  vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
--  vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
--  vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
--end
--
--lsp_zero.extend_lspconfig({
--  sign_text = true,
--  lsp_attach = lsp_attach,
--  float_border = 'rounded',
--  capabilities = require('cmp_nvim_lsp').default_capabilities(),
--})
--
--lsp_zero.format_on_save({
--  format_opts = {
--    async = false,
--    timeout_ms = 10000,
--  },
--  servers = {
--    ['ts_ls'] = { 'javascript', 'typescript' },
--    ['lua_ls'] = { 'lua' },
--    ['pyright'] = { 'python' },
--    ['html'] = { 'html' },
--    ['gopls'] = { 'go' },
--    ['goimports'] = { 'go' },
--    ["svelte"] = { "svelte" },
--    ["terraformls"] = { "terraform", "terraform-vars" },
--    ["solargraph"] = { "ruby" },
--
--  }
--})
--
----local servers = {
----  terraformls = {
----    filetype = { 'tf', "terraform", "terraform-vars" }
----  }
----}
--local util = require("lspconfig/util")
--
--require('mason').setup({})
--require('mason-lspconfig').setup({
--  -- Replace the language servers listed here
--  -- with the ones you want to install
--  ensure_installed = {
--    'rust_analyzer',
--    'tailwindcss',
--    'gopls',
--    'ts_ls',
--    'pyright',
--    'bashls',
--    'html',
--    'lua_ls',
--    'puppet',
--    'yamlls',
--    'terraformls',
--    'docker_compose_language_service',
--    'dockerls',
--  },
--  handlers = {
--    function(server_name)
--      require('lspconfig')[server_name].setup({
--        --        filetypes = (servers[server_name] or {}).filetype
--      })
--    end,
--
--    lua_ls = function()
--      local lua_opts = lsp_zero.nvim_lua_ls()
--      require("lspconfig").lua_ls.setup(lua_opts)
--    end,
--
--    rust_analyzer = function()
--      require("lspconfig").rust_analyzer.setup({
--        filetype = { "rust" },
--        root_dir = util.root_pattern("Cargo.toml"),
--        settings = {
--          ['rust-analyzer'] = {
--            cargo = {
--              allFeatures = true,
--            },
--          },
--        },
--        on_attach = function(client, bufnr)
--          vim.lsp.inlay_hint.enable(true)
--        end
--      })
--    end
--  },
--})
--
--local cmp = require('cmp')
--local cmp_action = require('lsp-zero').cmp_action()
--local cmp_format = require('lsp-zero').cmp_format({ details = true })
--
--cmp.setup({
--  preselect = 'item',
--  completion = {
--    completeopt = 'menu,menuone,noinsert'
--  },
--  sources = {
--    { name = 'path' },
--    { name = 'nvim_lsp' },
--    { name = 'luasnip', keyword_length = 2 },
--    { name = 'buffer',  keyword_length = 3 },
--    { name = "crates" },
--  },
--  window = {
--    completion = cmp.config.window.bordered(),
--    documentation = cmp.config.window.bordered(),
--  },
--  snippet = {
--    expand = function(args)
--      -- You need Neovim v0.10 to use vim.snippet
--      require('luasnip').lsp_expand(args.body)
--    end,
--  },
--  formatting = cmp_format,
--  mapping = cmp.mapping.preset.insert({
--    ['<C-Space>'] = cmp.mapping.complete(),
--    ['<C-e>'] = cmp.mapping.close(),
--    ['<C-y>'] = cmp.mapping.confirm({ select = false }),
--  }),
--})
