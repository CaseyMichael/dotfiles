-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Plugin-specific keymaps have been moved to their respective plugin files in lua/plugins/
-- See: codesnap.lua, mini-surround.lua, telescope-pnpm-monorepo.lua, nvim-lspconfig.lua, bufferline.lua

-- Custom yank file name
vim.keymap.set("n", "<leader>fy", function()
	local filename = vim.fn.expand("%:t")
	vim.fn.setreg("+", filename)
	print("Yanked relative path: " .. filename)
end, { desc = "Yank file name" })

-- Restore H and L to original Vim screen motions (disable LazyVim's buffer navigation)
vim.keymap.set("n", "H", function()
	vim.cmd("normal! H")
end, { desc = "Move to top of screen", silent = true })
vim.keymap.set("n", "L", function()
	vim.cmd("normal! L")
end, { desc = "Move to bottom of screen", silent = true })
