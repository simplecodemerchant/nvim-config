require("harpoon").setup({
    -- enable tabline with harpoon marks
    tabline = true,
    tabline_prefix = "   ",
    tabline_suffix = "   ",
})

local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<leader>a", mark.add_file)
vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)

vim.keymap.set("n", "<leader>a1", function() ui.nav_file(1) end, {noremap = true})
vim.keymap.set("n", "<leader>a2", function() ui.nav_file(2) end, {noremap = true})
vim.keymap.set("n", "<leader>a3", function() ui.nav_file(3) end)
vim.keymap.set("n", "<leader>a4", function() ui.nav_file(4) end)
vim.keymap.set("n", "<A-]>", function() ui.nav_next() end, {noremap = true})
vim.keymap.set("n", "<A-[>", function() ui.nav_prev() end, {noremap = true})


vim.cmd('highlight! HarpoonInactive guibg=NONE guifg=#63698c')
vim.cmd('highlight! HarpoonActive guibg=NONE guifg=white')
vim.cmd('highlight! HarpoonNumberActive guibg=NONE guifg=#7aa2f7')
vim.cmd('highlight! HarpoonNumberInactive guibg=NONE guifg=#7aa2f7')
vim.cmd('highlight! TabLineFill guibg=NONE guifg=white')
