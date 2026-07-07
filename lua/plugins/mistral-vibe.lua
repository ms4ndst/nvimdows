-- Second AI agent, docked the same way as Claude Code (plugins/claude-code.lua):
-- a real CLI in a terminal split, not a reimplemented chat UI. There's no
-- dedicated `vibe`-wrapper plugin the way claude-code.nvim wraps `claude`, so
-- this uses toggleterm.nvim's named-terminal support to get the same "toggle
-- a docked terminal running one specific command" behavior generically.
--
-- Mistral Vibe also speaks the Agent Client Protocol (ACP) for editors that
-- want inline diffs/chat instead of a plain terminal -- see the README's
-- "Swap the AI integration" section for `carlos-algms/agentic.nvim` if you
-- want that instead of this simpler terminal-docking approach.
--
-- Requires: the `vibe` CLI on PATH and already configured (`vibe --setup`,
-- or a `MISTRAL_API_KEY` environment variable) -- see
-- https://docs.mistral.ai/mistral-vibe/introduction. If `vibe` isn't
-- installed, toggling this just shows "command not found" in the terminal;
-- it doesn't affect anything else in the config.

-- Half the screen width, matching Claude Code's split_ratio (plugins/claude-code.lua).
local function vibe_width()
  return math.floor(vim.o.columns * 0.5)
end

-- Created once and reused (not per-keypress) so toggling actually shows/hides
-- the same terminal instead of spawning a new `vibe` process every time.
local vibe_terminal

local function toggle_vibe()
  if not vibe_terminal then
    vibe_terminal = require("toggleterm.terminal").Terminal:new({
      cmd = "vibe",
      direction = "vertical", -- mirrors Claude Code's right-hand split
      hidden = true,
    })
  end
  -- toggleterm reads window size from the argument passed to :toggle()/:open(),
  -- NOT from the `size` field on the Terminal object -- passing it here (every
  -- time, since the window may have been manually resized since) is the only
  -- way this actually takes effect; setting size in Terminal:new() is silently
  -- ignored and falls back to toggleterm's own small global default.
  vibe_terminal:toggle(vibe_width(), "vertical")
end

return {
  "akinsho/toggleterm.nvim",
  -- "MistralVibe" isn't a real command yet -- lazy.nvim stubs it, loads the
  -- plugin on first use, and the config() below defines it for real so the
  -- dashboard button (<cmd>MistralVibe<CR>) has something to call.
  cmd = { "ToggleTerm", "MistralVibe" },
  keys = {
    { "<leader>av", toggle_vibe, desc = "Toggle Mistral Vibe" },
  },
  opts = {
    -- Also set the global default (used by a bare :ToggleTerm) to the same
    -- 50/50 split, for consistency even though nothing else here uses it yet.
    size = function(term)
      if term.direction == "vertical" then
        return vibe_width()
      end
      return 15
    end,
  },
  config = function(_, opts)
    require("toggleterm").setup(opts)
    vim.api.nvim_create_user_command("MistralVibe", toggle_vibe, { desc = "Toggle Mistral Vibe" })
  end,
}
