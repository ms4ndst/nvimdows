-- nvim-cmp: the completion engine (the popup menu itself). This is separate
-- from LSP -- lspconfig produces completion *candidates*, cmp is what
-- collects candidates from multiple sources (LSP, snippets, open buffers,
-- filesystem paths) and renders/accepts them.

return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp", -- source: language server suggestions
      "hrsh7th/cmp-buffer", -- source: words from open buffers
      "hrsh7th/cmp-path", -- source: filesystem paths
      {
        "L3MON4D3/LuaSnip", -- snippet engine
        -- Builds the native jsregexp lib needed for snippet variable/placeholder
        -- transforms (an optional, narrow feature -- everything else about
        -- completion/snippets works without it). Needs `make` AND a plain
        -- `gcc` on PATH: this native Windows `make` runs recipe commands via
        -- raw CreateProcess with no shell involved, so a multi-word CC
        -- override like `zig cc` can't work (Windows can't resolve "zig cc"
        -- as one executable without a shell to split it) -- `zig` can't
        -- substitute for gcc here the way it does for Treesitter's build.
        -- Silently skipped if either tool is missing, so it never breaks the
        -- rest of the install.
        build = function(plugin)
          local make = vim.fn.exepath("make")
          local gcc = vim.fn.exepath("gcc")
          if make == "" or gcc == "" then
            return
          end
          vim.system({ make, "install_jsregexp" }, { cwd = plugin.dir }):wait()
        end,
      },
      "saadparwaiz1/cmp_luasnip", -- source: snippets from LuaSnip
      "rafamadriz/friendly-snippets", -- a large pre-built snippet collection
      "onsails/lspkind.nvim", -- adds icons/labels to completion items
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")

      require("luasnip.loaders.from_vscode").lazy_load() -- pulls in friendly-snippets

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = false }), -- only confirm an explicitly selected item
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
        formatting = {
          format = lspkind.cmp_format({ mode = "symbol_text", maxwidth = 50 }),
        },
      })

      -- Use buffer-only source (no LSP noise) when searching with / or ?
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = "buffer" } },
      })

      -- Path + command completion on the : command line
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
      })
    end,
  },
  { "hrsh7th/cmp-cmdline" },
}
