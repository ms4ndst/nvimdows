-- Entry point. Kept intentionally thin: set the leader key before anything
-- loads (plugins read it at setup time), then hand off to lazy.nvim.

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.lazy-bootstrap")
require("config.options")
require("config.keymaps")
require("config.autocmds")
