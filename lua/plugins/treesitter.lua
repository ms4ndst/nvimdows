-- Treesitter: gives Neovim a real syntax tree instead of regex-based
-- highlighting. This is what makes highlighting, indentation, and
-- text-object selection (e.g. "select inside function") accurate for every
-- language below. LSP (lsp.lua) is separate -- Treesitter does NOT provide
-- diagnostics, completion, or go-to-definition, only parsing.
--
-- Pinned to the `master` branch on purpose: nvim-treesitter's newer `main`
-- branch hard-requires a standalone `tree-sitter-cli` binary (their docs
-- explicitly warn against installing it via npm), which is an extra,
-- fragile Windows dependency. `master` only needs the C compiler already
-- required below (zig cc) and uses the same compiler-based build this repo
-- is set up for.

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "master",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  main = "nvim-treesitter.configs",
  opts = {
    ensure_installed = {
      "lua",
      "vim",
      "vimdoc",
      "query",
      "python",
      "javascript",
      "typescript",
      "tsx",
      "html",
      "css",
      "json",
      "yaml",
      "toml",
      "markdown",
      "markdown_inline",
      "bash",
      "powershell",
      "gitignore",
      "regex",
    },
    auto_install = true, -- install a parser automatically on first opening a new filetype
    highlight = { enable = true },
    indent = { enable = true },
  },
}
