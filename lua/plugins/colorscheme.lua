-- Catppuccin: the theme. Chosen over alternatives (tokyonight, gruvbox)
-- because it ships first-class integrations for every other plugin in this
-- config (Telescope, Neo-tree, nvim-cmp, Gitsigns, which-key) out of the box,
-- so nothing looks half-themed.

return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000, -- load before other plugins so UI elements pick up colors immediately
  opts = {
    flavour = "mocha", -- latte | frappe | macchiato | mocha
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
  },
  config = function(_, opts)
    require("catppuccin").setup(opts)
    vim.cmd.colorscheme("catppuccin")
  end,
}
