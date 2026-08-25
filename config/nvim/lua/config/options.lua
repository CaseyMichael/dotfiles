-- LazyVim already sets mapleader, termguicolors, and clipboard (it skips
-- clipboard over SSH so OSC 52 keeps working). Only add what differs.

-- Cursor configuration
vim.opt.guicursor = {
	"n-v-c:block", -- Normal, Visual, Command: block cursor
	"i-ci-ve:ver25-blinkwait700-blinkoff400-blinkon250", -- Insert: vertical bar (25% width) with blinking
	"r-cr-o:hor20", -- Replace: horizontal bar (20% height)
}

-- Command-line completion
vim.opt.wildmode = "longest:full,full" -- Complete longest common part, then show menu
vim.opt.wildignorecase = true -- Case-insensitive completion

vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- Disable unused language providers to reduce warnings
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
