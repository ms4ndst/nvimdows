-- Persists the chosen Catppuccin flavour across restarts and applies it
-- everywhere that needs to know about it (colorscheme, statusline). This is
-- the one place that understands "what flavour is active" so
-- plugins/colorscheme.lua, plugins/lualine.lua, and plugins/dashboard.lua
-- (the theme-picker button) can all stay in sync without duplicating logic.
--
-- catppuccin.nvim itself already implements the correct semantic role
-- mapping for every flavour (backgrounds, text, accents, etc.) -- this
-- module only decides *which* of its four flavours is active and makes that
-- choice durable, it does not touch colors directly.

local M = {}

local FLAVOURS = { "latte", "frappe", "macchiato", "mocha" }
local STATE_FILE = vim.fn.stdpath("state") .. "/nvimdows-theme.txt"

function M.flavours()
  return FLAVOURS
end

--- Reads the last-saved flavour, falling back to Mocha if none was saved
--- yet (first run) or the saved value is no longer a valid flavour name.
function M.load()
  local file = io.open(STATE_FILE, "r")
  if not file then
    return "mocha"
  end
  local saved = file:read("*l")
  file:close()
  if saved and vim.tbl_contains(FLAVOURS, saved) then
    return saved
  end
  return "mocha"
end

function M.save(flavour)
  local file = io.open(STATE_FILE, "w")
  if file then
    file:write(flavour)
    file:close()
  end
end

--- The lualine options table. Centralized here (rather than duplicated
--- between plugins/lualine.lua and the live-switch path below) since both
--- need to build the exact same options, just with a different flavour name
--- baked into `theme`.
function M.lualine_opts()
  return {
    options = {
      theme = "catppuccin-" .. M.load(),
      globalstatus = true,
      disabled_filetypes = { statusline = { "alpha" } }, -- keep the Nvimdows dashboard free of a statusline
    },
    sections = {
      lualine_c = { { "filename", path = 1 } }, -- relative path instead of just the basename
      lualine_x = { "diagnostics", "encoding", "filetype" },
    },
  }
end

--- Switches to `flavour` immediately (colorscheme + statusline) and
--- persists it for the next launch.
function M.apply(flavour)
  if not vim.tbl_contains(FLAVOURS, flavour) then
    return
  end

  require("catppuccin").setup({ flavour = flavour })
  vim.cmd.colorscheme("catppuccin")
  M.save(flavour)

  -- lualine only reads the flavour at its own setup() call, so re-run it to
  -- pick up the change now instead of on next launch.
  local ok, lualine = pcall(require, "lualine")
  if ok then
    lualine.setup(M.lualine_opts())
  end
end

--- Opens an interactive picker (built-in vim.ui.select, no extra plugin
--- needed) listing all four flavours and applies whichever one is chosen.
function M.pick()
  vim.ui.select(FLAVOURS, {
    prompt = "Nvimdows theme (Catppuccin flavour):",
    format_item = function(item)
      return item:sub(1, 1):upper() .. item:sub(2)
    end,
  }, function(choice)
    if choice then
      M.apply(choice)
    end
  end)
end

return M
