-- Core editor settings. Two blocks: sane defaults for everyone, then a
-- Windows-specific block that only applies when running on win32.

local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.wrap = false
opt.scrolloff = 8
opt.termguicolors = true

opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.autoindent = true

opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true

opt.splitright = true
opt.splitbelow = true

opt.undofile = true
opt.swapfile = false
opt.updatetime = 250
opt.timeoutlen = 400

opt.clipboard = "unnamedplus" -- share the OS clipboard (register + / *)
opt.mouse = "a"

opt.completeopt = { "menu", "menuone", "noselect" }

-- ---------------------------------------------------------------------------
-- Windows-specific
-- ---------------------------------------------------------------------------
if vim.fn.has("win32") == 1 then
  -- Use forward slashes internally so plugins that shell out (fzf, rg, git)
  -- behave the same as they would on Linux/macOS.
  opt.shellslash = true

  -- Prefer PowerShell 7 (pwsh) if installed, otherwise fall back to the
  -- Windows-provided powershell.exe. Both are set up with the argument
  -- flags Neovim expects for :! and job control to behave correctly.
  local pwsh = vim.fn.executable("pwsh") == 1 and "pwsh" or "powershell"
  opt.shell = pwsh
  opt.shellcmdflag =
    "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
  opt.shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait"
  opt.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
  opt.shellquote = ""
  opt.shellxquote = ""
end
