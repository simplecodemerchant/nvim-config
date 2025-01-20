local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    'nvim-telescope/telescope.nvim',
    version = '0.1.5',
    dependencies = { { 'nvim-lua/plenary.nvim' } }
  },
  { 'echasnovski/mini.nvim',            version = false },

  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    branch = "master",
  },

  'nvim-treesitter/playground',

  'theprimeagen/harpoon',

  'mbbill/undotree',

  'tpope/vim-fugitive',

  -- { 'VonHeikemen/lsp-zero.nvim',        branch = 'v4.x' },
  { 'neovim/nvim-lspconfig' },
  { 'williamboman/mason.nvim' },
  { 'williamboman/mason-lspconfig.nvim' },
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'hrsh7th/nvim-cmp' },
  -- { 'hrsh7th/cmp-buffer' },
  -- { 'hrsh7th/cmp-path' },
  {
    "L3MON4D3/LuaSnip",
    -- follow latest release.
    version = "v2.3.0",
    -- install jsregexp (optional!).
    build = "make install_jsregexp"
  },
  "saadparwaiz1/cmp_luasnip",
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "kdheepak/lazygit.nvim",
    -- optional for floating window border decoration
    -- dependencies = {
    --   "nvim-telescope/telescope.nvim",
    --   "nvim-lua/plenary.nvim",
    -- },
  --   config = function()
  --     require("telescope").load_extension("lazygit")
  --   end,
  },
  {
    "folke/trouble.nvim",
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },
  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
      input = {},
      terminal = {},
      words = {},
    },
    keys = {
      { "<leader>gb", function() Snacks.git.blame_line() end,          desc = "Git Blame Line" },
      { "<leader>gf", function() Snacks.lazygit.log_file() end,        desc = "Lazygit Current File History" },
      { "<leader>gg", function() Snacks.lazygit() end,                 desc = "Lazygit" },
      { "<leader>gl", function() Snacks.lazygit.log() end,             desc = "Lazygit Log (cwd)" },
      { "<leader>un", function() Snacks.notifier.hide() end,           desc = "Dismiss All Notifications" },
      { "<c-/>",      function() Snacks.terminal() end,                desc = "Toggle Terminal" },
      { "<c-_>",      function() Snacks.terminal() end,                desc = "which_key_ignore" },
      { "]]",         function() Snacks.words.jump(vim.v.count1) end,  desc = "Next Reference",              mode = { "n", "t" } },
      { "[[",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference",              mode = { "n", "t" } },
    },
  }
  --{
  --  'saecki/crates.nvim',
  --  tag = 'stable',
  --  config = function()
  --    require('crates').setup {
  --      completion = {
  --        cmp = {
  --          enabled = true,
  --        },
  --      },
  --    }
  --  end,
  --},
  --{
  --  'saghen/blink.cmp',
  --  dependencies = 'rafamadriz/friendly-snippets',

  --  version = '*',
  --  opts = {
  --    keymap = { preset = 'default' },

  --    appearance = {
  --      use_nvim_cmp_as_default = true,
  --      nerd_font_variant = 'mono'
  --    },
  --    sources = {
  --      default = { 'lsp', 'path', 'snippets', 'buffer' },
  --    },
  --  },
  --  opts_extend = { "sources.default" }
  --},
  --{
  --  "danielfalk/smart-open.nvim",
  --  branch = "0.2.x",
  --  config = function()
  --    require("telescope").load_extension("smart_open")
  --  end,
  --  dependencies = {
  --    "kkharji/sqlite.lua",
  --    -- Only required if using match_algorithm fzf
  --    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  --    -- Optional.  If installed, native fzy will be used when match_algorithm is fzy
  --    { "nvim-telescope/telescope-fzy-native.nvim" },
  --  },
  --},

  --{
  --  'rose-pine/neovim',
  --  name = 'rose-pine',
  --  config = function()
  --    vim.cmd.colorscheme('rose-pine')
  --  end
  --},
  -- { "nvim-tree/nvim-tree.lua" },
  -- { "Bilal2453/luvit-meta",      lazy = true }, -- optional `vim.uv` typings
  --{                                          -- optional completion source for require statements and module annotations
  --  "hrsh7th/nvim-cmp",
  --  opts = function(_, opts)
  --    opts.sources = opts.sources or {}
  --    table.insert(opts.sources, {
  --      name = "lazydev",
  --      group_index = 0, -- set group index to 0 to skip loading LuaLS completions
  --    })
  --  end,
  --},
  --{ 'nvim-lualine/lualine.nvim', dependencies = { 'nvim-tree/nvim-web-devicons' } },

  --{
  --  'romgrk/barbar.nvim',
  --  dependencies = {
  --    'lewis6991/gitsigns.nvim',     -- OPTIONAL: for git status
  --    'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
  --  },
  --  init = function() vim.g.barbar_auto_setup = false end,
  --  opts = {
  --    -- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
  --    -- animation = true,
  --    -- insert_at_start = true,
  --    -- …etc.
  --  },
  --  version = '^1.0.0', -- optional: only update when a new 1.x version is released
  --},
})
