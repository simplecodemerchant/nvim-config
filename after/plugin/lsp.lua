local lsp_zero = require('lsp-zero')

require("neodev").setup({
  -- add any options here, or leave empty to use the default settings
})

lsp_zero.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp_zero.default_keymaps({buffer = bufnr})
end)

local lspconfig = require("lspconfig")
local on_attach = require("lspconfig").on_attach
local capabilities = require("lspconfig").capabilties
local util = require("lspconfig/util")

-- here you can setup the language servers 
lspconfig.lua_ls.setup({
    settings = {
    Lua = {
      completion = {
        callSnippet = "Replace"
      }
    }
  }
})

lspconfig.rust_analyzer.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    filetype = {"rust"},
    root_dir = util.root_pattern("Cargo.toml"),
    settings = {
        ['rust-analyzer'] = {
            cargo = {
                allFeatures = true,
            },
        },
    },
})

require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {
    'rust_analyzer',
  },
  handlers = {
    lsp_zero.default_setup,
  },
})


local cmp = require('cmp')
local cmp_action = lsp_zero.cmp_action()

 cmp.setup({
     formatting = lsp_zero.cmp_format(),
     mapping = cmp.mapping.preset.insert({

         ['<Tab>'] = cmp_action.luasnip_supertab(),
         ['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
         ['<C-Space>'] = cmp.mapping.confirm({select = true}),
         ['<CR>'] = cmp.mapping.confirm({select = true}),
     }),
     sources = {
            { name = "crates" }
     }
 })

--lsp_zero.set_preferences({
--    suggest_lsp_servers = false,
--    sign_icons = {
--        error = 'E',
--        warn = 'W',
--        hint = 'H',
--        info = 'I'
--    }
--})
--
--
--
--lsp_zero.on_attach(function(client, bufnr)
--    -- see :help lsp-zero-keybindings
--    -- to learn the available actions
--    lsp_zero.default_keymaps({buffer = bufnr})
--end)
--
--require('mason').setup({})
--require('mason-lspconfig').setup({
--    ensure_installed = {
--        'tsserver',
--        'rust_analyzer',
--        'lua_ls',
--        'gopls',
--        'pyright',
--        'bashls',
--        'cssls',
--        'html',
--        'emmet_ls'
--    },
--    handlers = {
--        lsp_zero.default_setup,
--        lua_ls = function()
--            local lua_opts = lsp_zero.nvim_lua_ls()
--            require('lspconfig').lua_ls.setup(lua_opts)
--            --{
--            --    settings = {
--            --        Lua = {
--            --            diagnostics = {
--            --                globals = { 'vim' }
--            --            },
--            --            workspace = {
--            --                checkThirdParty = false,
--            --                library = {
--            --                    vim.env.VIMRUNTIME
--            --                    -- "${3rd}/luv/library"
--            --                    -- "${3rd}/busted/library",
--            --                }
--            --                -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
--            --                -- library = vim.api.nvim_get_runtime_file("", true)
--            --            }
--            --        }
--            --    }
--            --}
--            --)
--        end,
--        emmet_ls = function ()
--            require('lspconfig').emmet_ls.setup({})
--        end
--    },
--})
