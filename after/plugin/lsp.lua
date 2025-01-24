-- note: diagnostics are not exclusive to lsp serverslsp
-- so these can be global keybindings
-- vim.keymap.set('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')
-- vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
-- vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')


vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(args)
    local opts = { buffer = args.buf }

    -- these will be buffer-local keybindings
    -- because they only work if you have an active language server

    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    -- vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    -- vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
    -- vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
    -- vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
    -- vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
    -- vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
    -- vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
    -- vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
    -- vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)

    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if client ~= nil then
      if client:supports_method('textDocument/completion') then
        vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = false })
      end

      if client:supports_method('textDocument/formatting') then
        vim.api.nvim_create_autocmd('BufWritePre', {
          buffer = args.buf,
          callback = function()
            vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
          end,
        })
      end

      if client:supports_method('textDocument/inlayHint') then
        vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
      end

      if client:supports_method('textDocument/documentHighlight') then
        local autocmd = vim.api.nvim_create_autocmd
        local augroup = vim.api.nvim_create_augroup('lsp_highlight', { clear = false })

        vim.api.nvim_clear_autocmds({ buffer = args.buf, group = augroup })

        autocmd({ 'CursorHold' }, {
          group = augroup,
          buffer = args.buf,
          callback = vim.lsp.buf.document_highlight,
        })

        autocmd({ 'CursorMoved' }, {
          group = augroup,
          buffer = args.buf,
          callback = vim.lsp.buf.clear_references,
        })
      end
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
local ls = require('luasnip')
local lstypes = require('luasnip.util.types')

vim.snippet.expand = ls.lsp_expand

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
      ls.lsp_expand(args.body)
    end,

  },
})

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

require("luasnip.loaders.from_lua").lazy_load({ paths = "./snippets" })

vim.keymap.set({ "i", "s" }, "<c-k>", function()
  return vim.snippet.active { direction = 1 } and vim.snippet.jump(1)
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<c-j>", function()
  return vim.snippet.active { direction = -1 } and vim.snippet.jump(-1)
end, { silent = true })


ls.setup()
ls.config.set_config {
  history = true,
  update = 'TextChanged,TextChangedI',
  override_builtin = true,
}

ls.filetype_extend('js', { 'ts', 'tsx', 'jsx', 'mjs', 'cjs' })

--  LuaSnip Reference
--  local lazy_snip_env = {
--
-- 	s = function()
-- 		return require("luasnip.nodes.snippet").S
-- 	end,
-- 	sn = function()
-- 		return require("luasnip.nodes.snippet").SN
-- 	end,
-- 	isn = function()
-- 		return require("luasnip.nodes.snippet").ISN
-- 	end,
-- 	t = function()
-- 		return require("luasnip.nodes.textNode").T
-- 	end,
-- 	i = function()
-- 		return require("luasnip.nodes.insertNode").I
-- 	end,
-- 	f = function()
-- 		return require("luasnip.nodes.functionNode").F
-- 	end,
-- 	c = function()
-- 		return require("luasnip.nodes.choiceNode").C
-- 	end,
-- 	d = function()
-- 		return require("luasnip.nodes.dynamicNode").D
-- 	end,
-- 	r = function()
-- 		return require("luasnip.nodes.restoreNode").R
-- 	end,
-- 	events = function()
-- 		return require("luasnip.util.events")
-- 	end,
-- 	k = function()
-- 		return require("luasnip.nodes.key_indexer").new_key
-- 	end,
-- 	ai = function()
-- 		return require("luasnip.nodes.absolute_indexer")
-- 	end,
-- 	extras = function()
-- 		return require("luasnip.extras")
-- 	end,
-- 	l = function()
-- 		return require("luasnip.extras").lambda
-- 	end,
-- 	rep = function()
-- 		return require("luasnip.extras").rep
-- 	end,
-- 	p = function()
-- 		return require("luasnip.extras").partial
-- 	end,
-- 	m = function()
-- 		return require("luasnip.extras").match
-- 	end,
-- 	n = function()
-- 		return require("luasnip.extras").nonempty
-- 	end,
-- 	dl = function()
-- 		return require("luasnip.extras").dynamic_lambda
-- 	end,
-- 	fmt = function()
-- 		return require("luasnip.extras.fmt").fmt
-- 	end,
-- 	fmta = function()
-- 		return require("luasnip.extras.fmt").fmta
-- 	end,
-- 	conds = function()
-- 		return require("luasnip.extras.expand_conditions")
-- 	end,
-- 	postfix = function()
-- 		return require("luasnip.extras.postfix").postfix
-- 	end,
-- 	types = function()
-- 		return require("luasnip.util.types")
-- 	end,
-- 	parse = function()
-- 		return require("luasnip.util.parser").parse_snippet
-- 	end,
-- 	ms = function()
-- 		return require("luasnip.nodes.multiSnippet").new_multisnippet
-- 	end,
-- }
