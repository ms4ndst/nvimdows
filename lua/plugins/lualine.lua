-- Lualine: statusline. Shows mode, git branch, diagnostics, filetype, and
-- cursor position -- the information you'd otherwise have to check with
-- separate commands.
--
-- The theme name (catppuccin ships one lualine theme per flavour, e.g.
-- catppuccin-mocha, not a generic "catppuccin" theme) is built by
-- lua/config/theme.lua so it can't drift out of sync with whatever flavour
-- the theme picker last chose -- that module also re-runs this same opts
-- table when you switch flavours at runtime.

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons", "catppuccin/nvim" },
  event = "VeryLazy",
  opts = function()
    return require("config.theme").lualine_opts()
  end,
}
