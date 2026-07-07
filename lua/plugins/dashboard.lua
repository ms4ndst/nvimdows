-- Nvimdows start screen: shown only when Neovim opens with no file argument
-- (e.g. launched from a shortcut or a bare `nvim`). This is the branding
-- surface for the distribution -- an ASCII banner plus quick-launch buttons
-- for the features this config wires up that would otherwise only be
-- reachable via a keymap or `:Command` someone has to already know about.
-- Colored via Catppuccin's own alpha integration (see colorscheme.lua).

return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = function()
    local dashboard = require("alpha.themes.dashboard")

    dashboard.section.header.val = {
      "",
      "███╗   ██╗██╗   ██╗██╗███╗   ███╗██████╗  ██████╗ ██╗    ██╗███████╗",
      "████╗  ██║██║   ██║██║████╗ ████║██╔══██╗██╔═══██╗██║    ██║██╔════╝",
      "██╔██╗ ██║██║   ██║██║██╔████╔██║██║  ██║██║   ██║██║ █╗ ██║███████╗",
      "██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║██║  ██║██║   ██║██║███╗██║╚════██║",
      "██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║██████╔╝╚██████╔╝╚███╔███╔╝███████║",
      "╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝╚═════╝  ╚═════╝  ╚══╝╚══╝ ╚══════╝",
      "",
      "                    Windows-native Neovim · Catppuccin",
      "",
    }

    -- One button per built-in-feeling capability this config exposes.
    -- Grouped: file entry points, then search, then the tool/AI/health
    -- surfaces that would otherwise need a memorized :Command.
    dashboard.section.buttons.val = {
      dashboard.button("n", "  New file", "<cmd>enew<CR>"),
      dashboard.button("f", "  Find file", "<cmd>Telescope find_files<CR>"),
      dashboard.button("r", "  Recent files", "<cmd>Telescope oldfiles<CR>"),
      dashboard.button("g", "  Find text (grep)", "<cmd>Telescope live_grep<CR>"),
      dashboard.button("e", "  File explorer", "<cmd>Neotree toggle<CR>"),
      dashboard.button("s", "  Git status", "<cmd>Telescope git_status<CR>"),
      dashboard.button("a", "  Claude Code", "<cmd>ClaudeCode<CR>"),
      dashboard.button("m", "  Mason (LSP / tools)", "<cmd>Mason<CR>"),
      dashboard.button("l", "  Lazy (plugins)", "<cmd>Lazy<CR>"),
      dashboard.button("c", "  Edit config", "<cmd>edit " .. vim.fn.stdpath("config") .. "/init.lua<CR>"),
      dashboard.button("t", "  Choose theme", "<cmd>lua require('config.theme').pick()<CR>"),
      dashboard.button("h", "  Check health", "<cmd>checkhealth<CR>"),
      dashboard.button("q", "  Quit", "<cmd>qa<CR>"),
    }

    for _, button in ipairs(dashboard.section.buttons.val) do
      button.opts.hl = "AlphaButtons"
      button.opts.hl_shortcut = "AlphaShortcut"
    end

    local stats = require("lazy").stats()
    local ms = math.floor(stats.startuptime * 100 + 0.5) / 100
    dashboard.section.footer.val = ("⚡ Nvimdows loaded %d/%d plugins in %sms"):format(stats.loaded, stats.count, ms)

    dashboard.section.header.opts.hl = "AlphaHeader"
    dashboard.section.footer.opts.hl = "AlphaFooter"

    return dashboard.opts
  end,
  config = function(_, opts)
    require("alpha").setup(opts)
  end,
}
