-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--

-- LSP keymaps are now set in the LspAttach autocmd (see autocmds.lua)
-- This matches kickstart.nvim's approach and uses Telescope for navigation

-- Keep hover and signature help as global keymaps (useful everywhere)
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show hover documentation" })
vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { desc = "Show signature help" })
vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, { desc = "Show signature help (insert mode)" })

-- Diagnostic keymaps (global, work everywhere)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostics to location list" })

-- Custom yank file name
vim.keymap.set("n", "<leader>fy", function()
	local filename = vim.fn.expand("%:t")
	vim.fn.setreg("+", filename)
	print("Yanked relative path: " .. filename)
end, { desc = "Yank file name" })

-- Buffer navigation
vim.keymap.set("n", "<Tab>", ":bnext<CR>", { desc = "Cycle to next buffer", silent = true })
vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", { desc = "Cycle to previous buffer", silent = true })

-- Restore H and L to original Vim screen motions (disable LazyVim's buffer navigation)
vim.keymap.set("n", "H", function()
	vim.cmd("normal! H")
end, { desc = "Move to top of screen", silent = true })
vim.keymap.set("n", "L", function()
	vim.cmd("normal! L")
end, { desc = "Move to bottom of screen", silent = true })

-- CodeSnap keymaps
-- vim.keymap.set("x", "<leader>pc", "<cmd>CodeSnap<cr>", { desc = "[P]icture [c]lipboard" })
vim.keymap.set("x", "<leader>pc", function()
	vim.cmd("CodeSnap")
end, { desc = "[P]icture [c]lipboard" })

vim.keymap.set("x", "<leader>ps", function()
	local filename = string.format("codesnap-%s.png", os.date("%Y-%m-%d_%H-%M-%S"))
	local path = string.format("%s/Pictures/codesnap/%s", vim.fn.expand("~"), filename)
	vim.fn.mkdir(string.format("%s/Pictures/codesnap", vim.fn.expand("~")), "p")
	vim.cmd(string.format("CodeSnapSave %s", path))
end, { desc = "[P]icture [s]ave" })

vim.keymap.set("x", "<leader>pa", "<cmd>CodeSnapASCII<cr>", { desc = "[P]icture [a]scii" })
vim.keymap.set("x", "<leader>ph", "<cmd>CodeSnapHighlight<cr>", { desc = "[P]icture [h]ighlight" })

-- Disable default Vim "s" behavior to avoid conflicts with mini.surround
vim.keymap.set("n", "s", "<Nop>", { desc = "Disable default s behavior" })

-- Telescope monorepo
-- Set up keybinds as shown in the documentation
vim.keymap.set("n", "<leader>m", function()
	require("telescope").extensions.pnpm_monorepo.pnpm_monorepo()
end, { desc = "Open monorepo projects" })

-- Telescope
vim.keymap.set("n", "<leader>fw", function()
	require("telescope").extensions.pnpm.workspace()
end, { desc = "Open pnpm projects" })
