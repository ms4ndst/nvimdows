-- Neo-tree: sidebar file explorer. Telescope covers "jump to a known file
-- fast"; this covers "browse project structure visually" -- both are useful
-- and cover different habits, so both are included.

return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  cmd = "Neotree",
  keys = {
    { "<leader>e", "<cmd>Neotree toggle<CR>", desc = "Toggle file explorer" },
  },
  opts = {
    filesystem = {
      follow_current_file = { enabled = true },
      hijack_netrw_behavior = "open_current",
      use_libuv_file_watcher = true, -- works fine on Windows, no extra setup needed
    },
    window = {
      width = 32,
    },
  },
}
