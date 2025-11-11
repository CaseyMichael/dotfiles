-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- 

vim.keymap.set('n', '<leader>fp', function() require('telescope').extensions.pnpm_workspace.find_packages() end, { desc = 'Find pnpm packages' })

vim.keymap.set("n", "<leader>fy", function()
    local filename = vim.fn.expand('%:t')
    vim.fn.setreg("+", filename) -- Yank the relative path to the system clipboard
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

-- View notification history and messages
vim.keymap.set("n", "<leader>sn", function()
    -- Try noice history first, fallback to messages
    if pcall(require, "noice") then
        vim.cmd("Noice history")
    else
        vim.cmd("messages")
    end
end, { desc = "Notification History" })

vim.keymap.set("n", "<leader>sm", "<cmd>messages<cr>", { desc = "View All Messages" })

-- Disable LazyVim's default LSP keybindings that conflict with lspsaga
-- lspsaga handles these keys, so we unmap LazyVim's defaults
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client then
			-- Unmap LazyVim's default LSP keybindings to prevent conflicts with lspsaga
			local buf = args.buf
			vim.keymap.del("n", "gd", { buffer = buf })
			vim.keymap.del("n", "gD", { buffer = buf })
			vim.keymap.del("n", "gr", { buffer = buf })
			vim.keymap.del("n", "K", { buffer = buf })
			vim.keymap.del("n", "]d", { buffer = buf })
			vim.keymap.del("n", "[d", { buffer = buf })
		end
	end,
})