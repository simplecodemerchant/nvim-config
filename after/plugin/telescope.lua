local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', builtin.live_grep, {})
vim.keymap.set('n', '<leader>px', builtin.resume, {
    noremap = true,
    silent = true,
    desc = "Resume",
})
--vim.keymap.set('n', '<leader>ps', function()
--  builtin.grep_string({ search = vim.fn.input("Grep > ") })
--end)
vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})


local function visual_selection_range()
    local _, csrow, cscol, _ = unpack(vim.fn.getpos("'<"))
    local _, cerow, cecol, _ = unpack(vim.fn.getpos("'>"))
    if csrow < cerow or (csrow == cerow and cscol <= cecol) then
        return {csrow - 1, cscol - 1}, {cerow - 1, cecol}
    else
        return {cerow - 1, cecol - 1}, {csrow - 1, cscol}
    end
end

local function region_to_text(region)
    local text = ''
    local maxcol = vim.v.maxcol
    for line, cols in vim.spairs(region) do
        local endcol = cols[2] == maxcol and -1 or cols[2]
        local chunk = vim.api.nvim_buf_get_text(0, line, cols[1], line, endcol, {})[1]
        text = ('%s%s'):format(text, chunk)
    end
    return text
end

vim.keymap.set('v', '<leader>ps', function()
    local cs, ce = visual_selection_range()
    print(unpack(cs))
    print(unpack(ce))
    local r = vim.region(0, cs, ce, vim.fn.visualmode(), true)
    local text = region_to_text(r)
    print(text)
    -- builtin.live_grep({
    --     default_text = text
    -- })
end, {})
