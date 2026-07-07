-- Small editing-experience plugins bundled together since none needs more
-- than a few lines of config.

return {
  -- Shows every keymap and its description in a popup as soon as you start
  -- typing a chord (e.g. press <leader> and wait) -- makes every custom
  -- keymap in this config discoverable without reading the source.
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- Auto-closes brackets/quotes and is smart enough to skip over an
  -- already-typed closer instead of doubling it up.
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
    config = function(_, opts)
      require("nvim-autopairs").setup(opts)
      -- Make autopairs and nvim-cmp cooperate: pressing <CR> on a completion
      -- that opens a function call also inserts the matching paren.
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

  -- gc / gcc to toggle line/block comments using the correct comment
  -- syntax for the current filetype (works with Treesitter's understanding
  -- of embedded languages, e.g. JS inside HTML).
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },

  -- Vertical guide lines for indentation levels -- mostly a readability aid
  -- in deeply nested code.
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },
}
