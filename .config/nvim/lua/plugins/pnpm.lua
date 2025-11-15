return {
	"lukahartwig/pnpm.nvim",
	enabled = false,
	requires = {
		{ "nvim-telescope/telescope.nvim" },
	},
	config = function()
		local telescope = require("telescope")
		-- Set up keybinds as shown in the documentation
		vim.keymap.set("n", "<leader>fw", telescope.extensions.pnpm.workspace, { desc = "Open pnpm projects" })
	end,
}
