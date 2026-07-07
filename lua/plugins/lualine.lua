-- Lualine: statusline. Shows mode, git branch, diagnostics, filetype, and
-- cursor position -- the information you'd otherwise have to check with
-- separate commands.

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons", "catppuccin/nvim" },
  event = "VeryLazy",
  opts = function()
    -- catppuccin ships one lualine theme per flavour (catppuccin-mocha,
    -- catppuccin-latte, ...), not a generic "catppuccin" theme -- derive the
    -- name from whichever flavour colorscheme.lua has active so the two
    -- files can't drift out of sync if the flavour is ever changed.
    local theme = "catppuccin-" .. require("catppuccin").flavour

    return {
      options = {
        theme = theme,
        globalstatus = true,
        disabled_filetypes = { statusline = { "alpha" } }, -- keep the Nvimdows dashboard free of a statusline
      },
      sections = {
        lualine_c = { { "filename", path = 1 } }, -- relative path instead of just the basename
        lualine_x = { "diagnostics", "encoding", "filetype" },
      },
    }
  end,
}
