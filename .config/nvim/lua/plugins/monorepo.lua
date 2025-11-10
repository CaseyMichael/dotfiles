return {
	"CaseyPeters/monorepo.nvim",
	enabled = true,
	config = function()
		require("monorepo").setup({
			silent = false, -- Show vim.notify messages
			autoload_telescope = true, -- Automatically load telescope extension
			data_path = vim.fn.stdpath("data"), -- Where to save monorepo.json
		})
		-- Set up keybinds as shown in the documentation
		vim.keymap.set("n", "<leader>mm", function()
			require("telescope").extensions.monorepo.monorepo()
		end, { desc = "Open monorepo projects" })
		vim.keymap.set("n", "<leader>mt", function()
			require("monorepo").toggle_project()
		end, { desc = "Toggle monorepo project" })
	end,
	dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
}
