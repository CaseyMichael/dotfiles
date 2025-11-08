-- Set options (vim.opt)
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"

-- Cursor configuration
vim.opt.guicursor = {
  "n-v-c:block",                          -- Normal, Visual, Command: block cursor
  "i-ci-ve:ver25-blinkwait700-blinkoff400-blinkon250", -- Insert: vertical bar (25% width) with blinking
  "r-cr-o:hor20",                         -- Replace: horizontal bar (20% height)
}

-- Command-line completion
vim.opt.wildmenu = true -- Enable command-line completion menu
vim.opt.wildmode = "longest:full,full" -- Complete longest common part, then show menu
vim.opt.wildignorecase = true -- Case-insensitive completion
vim.opt.wildoptions = "pum" -- Use popup menu for wildmenu

-- Statusline
vim.opt.statusline = "%F %m %r %w%=%y %l:%c"

-- Set global options (vim.o)
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- Set global variables (vim.g)
vim.g.mapleader = " "
vim.g.root_spec = { "cwd" }

-- Configure Snacks UI handlers
vim.defer_fn(function()
	if pcall(require, "snacks.input") then
		vim.ui.input = require("snacks.input").input
	end
	if pcall(require, "snacks.picker") then
		vim.ui.select = require("snacks.picker").select
	end
end, 1000)

-- Disable unused language providers to reduce warnings
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
