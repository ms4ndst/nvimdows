-- Gitsigns: shows added/changed/removed lines in the sign column against
-- HEAD, plus hunk stage/preview/blame commands. Requires `git` on PATH --
-- nothing else.

return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    signs = {
      add = { text = "+" },
      change = { text = "~" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
    },
    on_attach = function(bufnr)
      local map = function(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
      end
      map("n", "]h", require("gitsigns").next_hunk, "Next git hunk")
      map("n", "[h", require("gitsigns").prev_hunk, "Previous git hunk")
      map("n", "<leader>hp", require("gitsigns").preview_hunk, "Preview git hunk")
      map("n", "<leader>hb", require("gitsigns").blame_line, "Blame line")
    end,
  },
}
