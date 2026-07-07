-- Catppuccin: the theme. Chosen over alternatives (tokyonight, gruvbox)
-- because it ships first-class integrations for every other plugin in this
-- config (Telescope, Neo-tree, nvim-cmp, Gitsigns, which-key) out of the box,
-- so nothing looks half-themed.
--
-- The active flavour is NOT hardcoded here -- it's whatever was last chosen
-- via the theme picker (<leader>ct, or the "Choose theme" dashboard button),
-- persisted by lua/config/theme.lua. Defaults to Mocha on first run.

return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000, -- load before other plugins so UI elements pick up colors immediately
  opts = function()
    return {
      flavour = require("config.theme").load(), -- latte | frappe | macchiato | mocha
      transparent_background = false,
      integrations = {
        cmp = true,
        gitsigns = true,
        neotree = true,
        telescope = true,
        which_key = true,
        treesitter = true,
        mason = true,
        native_lsp = { enabled = true },
        alpha = true, -- colors the Nvimdows start-screen dashboard (see plugins/dashboard.lua)
      },
    }
  end,
  config = function(_, opts)
    require("catppuccin").setup(opts)
    vim.cmd.colorscheme("catppuccin")
  end,
}
