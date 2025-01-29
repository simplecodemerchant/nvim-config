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
  { 'rebelot/kanagawa.nvim' },
  {
    'nvim-telescope/telescope.nvim',
    version = '0.1.5',
    dependencies = { { 'nvim-lua/plenary.nvim' } }
  },
  { 'echasnovski/mini.nvim', version = false },

  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    branch = "master",
  },

  'nvim-treesitter/playground',
  'nvim-tree/nvim-tree.lua',
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
      git = {},
      lazygit = {},
      words = {},
      picker = {},
      dim = {},
    },
    keys = {
      { "<leader>gb",      function() Snacks.git.blame_line() end,              desc = "Git Blame Line" },

      { "<leader>gf",      function() Snacks.lazygit.log_file() end,            desc = "Lazygit Current File History" },
      { "<leader>gg",      function() Snacks.lazygit() end,                     desc = "Lazygit" },
      { "<leader>gl",      function() Snacks.lazygit.log() end,                 desc = "Lazygit Log (cwd)" },

      { "<leader>un",      function() Snacks.notifier.hide() end,               desc = "Dismiss All Notifications" },

      { "]]",              function() Snacks.words.jump(vim.v.count1) end,      desc = "Next Reference",              mode = { "n", "t" } },
      { "[[",              function() Snacks.words.jump(-vim.v.count1) end,     desc = "Prev Reference",              mode = { "n", "t" } },

      { "<leader>,",       function() Snacks.picker.buffers() end,              desc = "Buffers" },
      { "<leader>/",       function() Snacks.picker.grep() end,                 desc = "Grep" },
      { "<leader>:",       function() Snacks.picker.command_history() end,      desc = "Command History" },
      { "<leader><space>", function() Snacks.picker.files() end,                desc = "Find Files" },
      -- find
      -- { "<leader>fb",      function() Snacks.picker.buffers() end,                                 desc = "Buffers" },
      -- { "<leader>fc",      function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
      { "<leader>ff",      function() Snacks.picker.files() end,                desc = "Find Files" },
      { "<leader>fg",      function() Snacks.picker.git_files() end,            desc = "Find Git Files" },
      { "<leader>fr",      function() Snacks.picker.recent() end,               desc = "Recent" },
      -- git
      { "<leader>gc",      function() Snacks.picker.git_log() end,              desc = "Git Log" },
      { "<leader>gs",      function() Snacks.picker.git_status() end,           desc = "Git Status" },
      -- Grep
      { "<leader>sb",      function() Snacks.picker.lines() end,                desc = "Buffer Lines" },
      { "<leader>sB",      function() Snacks.picker.grep_buffers() end,         desc = "Grep Open Buffers" },
      { "<leader>sg",      function() Snacks.picker.grep() end,                 desc = "Grep" },
      { "<leader>sw",      function() Snacks.picker.grep_word() end,            desc = "Visual selection or word",    mode = { "n", "x" } },
      -- search
      { '<leader>s"',      function() Snacks.picker.registers() end,            desc = "Registers" },
      { "<leader>sa",      function() Snacks.picker.autocmds() end,             desc = "Autocmds" },
      { "<leader>sc",      function() Snacks.picker.command_history() end,      desc = "Command History" },
      { "<leader>sC",      function() Snacks.picker.commands() end,             desc = "Commands" },
      { "<leader>sd",      function() Snacks.picker.diagnostics() end,          desc = "Diagnostics" },
      { "<leader>sh",      function() Snacks.picker.help() end,                 desc = "Help Pages" },
      { "<leader>sH",      function() Snacks.picker.highlights() end,           desc = "Highlights" },
      { "<leader>sj",      function() Snacks.picker.jumps() end,                desc = "Jumps" },
      { "<leader>sk",      function() Snacks.picker.keymaps() end,              desc = "Keymaps" },
      { "<leader>sl",      function() Snacks.picker.loclist() end,              desc = "Location List" },
      { "<leader>sM",      function() Snacks.picker.man() end,                  desc = "Man Pages" },
      { "<leader>sm",      function() Snacks.picker.marks() end,                desc = "Marks" },
      { "<leader>sR",      function() Snacks.picker.resume() end,               desc = "Resume" },
      { "<leader>sq",      function() Snacks.picker.qflist() end,               desc = "Quickfix List" },
      -- { "<leader>uC",      function() Snacks.picker.colorschemes() end,         desc = "Colorschemes" },
      { "<leader>qp",      function() Snacks.picker.projects() end,             desc = "Projects" },
      -- LSP
      { "gd",              function() Snacks.picker.lsp_definitions() end,      desc = "Goto Definition" },
      { "gr",              function() Snacks.picker.lsp_references() end,       nowait = true,                        desc = "References" },
      { "gI",              function() Snacks.picker.lsp_implementations() end,  desc = "Goto Implementation" },
      { "gy",              function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
      { "<leader>ss",      function() Snacks.picker.lsp_symbols() end,          desc = "LSP Symbols" },
    },
  }
})
