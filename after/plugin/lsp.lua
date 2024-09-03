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
        ['tsserver'] = { 'javascript', 'typescript' },
        ['lua_ls'] = { 'lua' },
        ['pyright'] = { 'python' },
        ['html'] = { 'html' },
        ['gopls'] = { 'go' },
        ["svelte"] = { "svelte" }
    }
})

local util = require("lspconfig/util")

require('mason').setup({})
require('mason-lspconfig').setup({
    -- Replace the language servers listed here
    -- with the ones you want to install
    ensure_installed = {
        'rust_analyzer',
        'tailwindcss',
        'gopls',
        'tsserver',
        'pyright',
        'bashls',
        'html',
        'lua_ls',
        'puppet',
        'yamlls'
    },
    handlers = {
        function(server_name)
            require('lspconfig')[server_name].setup({

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

--lsp_zero.on_attach(function(_, bufnr)
--    -- see :help lsp-zero-keybindings
--    -- to learn the available actions
--    lsp_zero.default_keymaps({ buffer = bufnr })
--end)
--
--local lspconfig = require("lspconfig")
--local util = require("lspconfig/util")
--
--require('mason').setup({})
--require('mason-lspconfig').setup({
--    ensure_installed = {
--        'rust_analyzer',
--        'tailwindcss',
--        'gopls',
--        'tsserver',
--        'pyright',
--        'bashls',
--        'html',
--        'lua_ls',
--        'puppet',
--        'yamlls'
--    },
--    handlers = {
--        lsp_zero.default_setup,
--
--        lua_ls = function()
--            local lua_opts = lsp_zero.nvim_lua_ls()
--            lspconfig.lua_ls.setup(lua_opts)
--        end,
--
--        rust_analyzer = function()
--            require("lspconfig").rust_analyzer.setup({
--                filetype = { "rust" },
--                root_dir = util.root_pattern("Cargo.toml"),
--                settings = {
--                    ['rust-analyzer'] = {
--                        cargo = {
--                            allFeatures = true,
--                        },
--                    },
--                },
--            })
--        end
--    },
--})
--
--
--local cmp = require('cmp')
--local cmp_action = lsp_zero.cmp_action()
--
--cmp.setup({
--    formatting = lsp_zero.cmp_format({}),
--    mapping = cmp.mapping.preset.insert({
--        ['<Tab>'] = cmp_action.luasnip_supertab(),
--        ['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
--        ['<C-Space>'] = cmp.mapping.confirm({ select = true }),
--        ['<CR>'] = cmp.mapping.confirm({ select = true }),
--    }),
--})
