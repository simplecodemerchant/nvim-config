function ColorMyPencils(color)
  color = color or "rose-pine"
  vim.cmd.colorscheme(color)

  local hl = vim.api.nvim_set_hl

  hl(0, "Normal", { bg = "none" })
  hl(0, "NormalFloat", { bg = "none" })

  hl(0, 'SignColumn', { clear })
  hl(0, 'StatusLine', { clear })

end

ColorMyPencils()
