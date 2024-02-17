local lsp_zero = require('lsp-zero')

require("neodev").setup({
    -- add any options here, or leave empty to use the default settings
})

lsp_zero.on_attach(function(client, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp_zero.default_keymaps({ buffer = bufnr })
end)

local lspconfig = require("lspconfig")
local util = require("lspconfig/util")

require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = {
        'rust_analyzer',
        'tailwindcss'
    },
    handlers = {
        lsp_zero.default_setup,

        lua_ls = function()
            local lua_opts = lsp_zero.nvim_lua_ls()
            lspconfig.lua_ls.setup(lua_opts)
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
local cmp_action = lsp_zero.cmp_action()

cmp.setup({
    formatting = lsp_zero.cmp_format(),
    mapping = cmp.mapping.preset.insert({
        --['<Tab>'] = cmp_action.luasnip_supertab(),
        ['<Tab>'] = cmp_action.mapping.confirm({select = true}),
        ['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
        ['<C-Space>'] = cmp.mapping.comlete(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
    })
})

lsp_zero.preset({
    suggest_lsp_servers = false,
    sign_icons = {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I'
    }
})
