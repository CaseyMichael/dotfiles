return {
	"nvim-lua/plenary.nvim", -- Ensure plenary is available
	event = "VeryLazy", -- Ensure this loads after LazyVim's defaults
	config = function()
		-- Tab to cycle forward through buffers
		vim.keymap.set("n", "<Tab>", ":bnext<CR>", { desc = "Cycle to next buffer", silent = true })

		-- Shift+Tab to cycle backward through buffers
		vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", { desc = "Cycle to previous buffer", silent = true })

		-- Restore H and L to original Vim screen motions (disable LazyVim's buffer navigation)
		vim.keymap.set("n", "H", function()
			vim.cmd("normal! H")
		end, { desc = "Move to top of screen", silent = true })
		vim.keymap.set("n", "L", function()
			vim.cmd("normal! L")
		end, { desc = "Move to bottom of screen", silent = true })
	end,
}
