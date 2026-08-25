-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Plugin-specific keymaps have been moved to their respective plugin files in lua/plugins/
-- See: codesnap.lua, mini-surround.lua, telescope-pnpm-monorepo.lua, bufferline.lua

-- Custom yank relative path from root
vim.keymap.set("n", "<leader>fy", function()
	local relative_path = vim.fn.expand("%:.")
	vim.fn.setreg("+", relative_path)
	vim.notify("Yanked relative path: " .. relative_path)
end, { desc = "Yank relative path from root" })
