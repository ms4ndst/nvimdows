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

-- Created once and reused (not per-keypress) so toggling actually shows/hides
-- the same terminal instead of spawning a new `vibe` process every time.
local vibe_terminal

local function toggle_vibe()
  if not vibe_terminal then
    vibe_terminal = require("toggleterm.terminal").Terminal:new({
      cmd = "vibe",
      direction = "vertical", -- mirrors Claude Code's right-hand split
      size = function()
        return math.floor(vim.o.columns * 0.4)
      end,
      hidden = true,
    })
  end
  vibe_terminal:toggle()
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
  opts = {},
  config = function(_, opts)
    require("toggleterm").setup(opts)
    vim.api.nvim_create_user_command("MistralVibe", toggle_vibe, { desc = "Toggle Mistral Vibe" })
  end,
}
