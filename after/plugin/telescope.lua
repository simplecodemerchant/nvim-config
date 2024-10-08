local M = {}
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
--vim.keymap.set('n', '<C-p>', builtin.git_files, {})
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
vim.keymap.set("n", "<leader><leader>", function()
  require("telescope").extensions.smart_open.smart_open({
    cwd_only = true
  })
end, { noremap = true, silent = true })

vim.keymap.set("n", "<leader>pg", function()
  require("telescope").extensions.smart_open.smart_open()
end, { noremap = true, silent = true })

function M.tbl_length(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function M.get_visual_selection()
  -- this will exit visual mode
  -- use 'gv' to reselect the text
  local _, csrow, cscol, cerow, cecol
  local mode = vim.fn.mode()
  if mode == 'v' or mode == 'V' or mode == '' then
    -- if we are in visual mode use the live position
    _, csrow, cscol, _ = unpack(vim.fn.getpos("."))
    _, cerow, cecol, _ = unpack(vim.fn.getpos("v"))
    if mode == 'V' then
      -- visual line doesn't provide columns
      cscol, cecol = 0, 999
    end
    -- exit visual mode
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes("<Esc>",
        true, false, true), 'n', true)
  else
    -- otherwise, use the last known visual position
    _, csrow, cscol, _ = unpack(vim.fn.getpos("'<"))
    _, cerow, cecol, _ = unpack(vim.fn.getpos("'>"))
  end
  -- swap vars if needed
  if cerow < csrow then csrow, cerow = cerow, csrow end
  if cecol < cscol then cscol, cecol = cecol, cscol end
  local lines = vim.fn.getline(csrow, cerow)
  -- local n = cerow-csrow+1
  local n = M.tbl_length(lines)
  if n <= 0 then return '' end
  lines[n] = string.sub(lines[n], 1, cecol)
  lines[1] = string.sub(lines[1], cscol)
  return table.concat(lines, "\n")
end

vim.keymap.set('v', '<leader>ps', function()
  local text = M.get_visual_selection()
  builtin.live_grep({
    default_text = text
  })
end, {})
