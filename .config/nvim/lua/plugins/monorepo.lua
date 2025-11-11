return {
	"CaseyPeters/monorepo.nvim",
	dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
	config = function()
		require("monorepo").setup({
			silent = false,
			autoload_telescope = true,
			data_path = vim.fn.stdpath("data"),
		})
	end,
	keys = {
		{ "<leader>mm", function()
			require("telescope").extensions.monorepo.monorepo()
		end, desc = "Open monorepo projects" },
		{ "<leader>mt", function()
			require("monorepo").toggle_project()
		end, desc = "Toggle monorepo project" },
	},
}
