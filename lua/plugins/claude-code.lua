-- AI agent integration. Rather than reimplementing a chat UI against a raw
-- API key, this wraps the `claude` CLI (Claude Code) you already have
-- installed and authenticated -- it runs in a real terminal split inside
-- Neovim, so it is the exact same agent as your terminal, just docked.
--
-- Requires: the `claude` CLI on PATH and already logged in
-- (`claude /login` once, outside Neovim, if you haven't).

return {
  "greggh/claude-code.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = { "ClaudeCode", "ClaudeCodeContinue", "ClaudeCodeVerbose" },
  keys = {
    { "<leader>ac", "<cmd>ClaudeCode<CR>", desc = "Toggle Claude Code" },
    { "<leader>ar", "<cmd>ClaudeCodeContinue<CR>", desc = "Resume last Claude Code session" },
  },
  opts = {
    window = {
      position = "vertical", -- docks Claude in a right-hand split
      split_ratio = 0.5, -- matches Mistral Vibe's width (plugins/mistral-vibe.lua) so either agent gets half the screen
    },
    keymaps = {
      toggle = { normal = "<C-,>", terminal = "<C-,>" }, -- quick toggle from anywhere, including insert-mode-of-the-terminal
    },
  },
}
