-- Language Server Protocol stack. This is what provides diagnostics,
-- go-to-definition, hover docs, rename, and code actions -- i.e. the "IDE"
-- part of the config. Split into three pieces:
--   mason.nvim          -> installs the LSP server binaries themselves
--   mason-lspconfig.nvim -> bridges Mason's install names to lspconfig's names
--   nvim-lspconfig       -> ships default per-server configs consumed by
--                           Neovim's built-in vim.lsp.config()/vim.lsp.enable()
--                           (the old `require('lspconfig').server.setup()`
--                           call style is deprecated as of nvim-lspconfig
--                           targeting Neovim 0.11+, so this file uses the
--                           native API instead)

return {
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    opts = {
      ui = { border = "rounded" },
    },
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      -- Servers to auto-install on first launch. Add a language server's
      -- Mason name here to get it for free next time Neovim starts.
      ensure_installed = {
        "lua_ls", -- Lua
        "pyright", -- Python
        "ts_ls", -- JavaScript / TypeScript
        "html",
        "cssls",
        "jsonls",
        "powershell_es", -- PowerShell -- included since this config targets Windows
        "marksman", -- Markdown
      },
      -- Defaults to true: enables each server (via vim.lsp.enable) as soon
      -- as Mason finishes installing it, using whatever config was
      -- registered for it in nvim-lspconfig's setup below.
      automatic_enable = true,
    },
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp", -- advertises nvim-cmp's completion capabilities to each server
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Keymaps are attached only to buffers that actually have an LSP
      -- client running, via the LspAttach autocommand -- this avoids
      -- clobbering global keymaps for filetypes with no server.
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          map("gd", vim.lsp.buf.definition, "Go to definition")
          map("gr", vim.lsp.buf.references, "Go to references")
          map("gI", vim.lsp.buf.implementation, "Go to implementation")
          map("K", vim.lsp.buf.hover, "Hover documentation")
          map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
          map("<leader>ca", vim.lsp.buf.code_action, "Code action")
          map("<leader>D", vim.lsp.buf.type_definition, "Type definition")
          map("[d", vim.diagnostic.goto_prev, "Previous diagnostic")
          map("]d", vim.diagnostic.goto_next, "Next diagnostic")
          map("<leader>e", vim.diagnostic.open_float, "Show diagnostic")
        end,
      })

      local servers = {
        lua_ls = {
          -- nvim-lspconfig's shipped default already sets sensible
          -- root_markers (.luarc.json, .git, stylua.toml, ...); if none are
          -- found searching upward from the file, it attaches without a
          -- workspace root (single-file mode) rather than guessing -- no
          -- override needed here, just the extra settings below.
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } }, -- silence "undefined global vim" in this very config
              workspace = { checkThirdParty = false },
            },
          },
        },
        pyright = {},
        ts_ls = {},
        html = {},
        cssls = {},
        jsonls = {},
        powershell_es = {
          bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services",
        },
        marksman = {},
      }

      vim.lsp.config("*", { capabilities = capabilities }) -- merged as defaults into every server below
      for server, config in pairs(servers) do
        vim.lsp.config(server, config)
      end
      vim.lsp.enable(vim.tbl_keys(servers))

      vim.diagnostic.config({
        virtual_text = { prefix = "●" },
        severity_sort = true,
        float = { border = "rounded" },
      })
    end,
  },

  -- Formatting on save. Kept separate from LSP servers because not every
  -- LSP server formats well (or at all) -- conform lets each filetype pick
  -- a dedicated formatter instead.
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>f",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        desc = "Format buffer",
      },
    },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "black" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        json = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        markdown = { "prettier" },
        yaml = { "prettier" },
      },
      format_on_save = {
        timeout_ms = 1000,
        lsp_fallback = true,
      },
    },
  },

  -- Installs the formatter binaries referenced above, the same way
  -- mason-lspconfig installs LSP servers.
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = { "stylua", "black", "prettier" },
    },
  },
}
