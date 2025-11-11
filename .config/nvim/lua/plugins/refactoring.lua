return {
	"ThePrimeagen/refactoring.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	keys = {
		{ "<leader>rr", function()
			require("refactoring").select_refactor()
		end, mode = { "n", "v" }, desc = "Refactor" },
		{ "<leader>rb", function()
			require("refactoring").refactor("Extract Block")
		end, mode = "v", desc = "Extract Block" },
		{ "<leader>rf", function()
			require("refactoring").refactor("Extract Function")
		end, mode = "v", desc = "Extract Function" },
		{ "<leader>rv", function()
			require("refactoring").refactor("Extract Variable")
		end, mode = "v", desc = "Extract Variable" },
		{ "<leader>ri", function()
			require("refactoring").refactor("Inline Variable")
		end, mode = { "n", "v" }, desc = "Inline Variable" },
	},
	config = function()
		require("refactoring").setup({
			prompt_func_return_type = {
				typescript = true,
				javascript = true,
			},
			prompt_func_param_type = {
				typescript = true,
				javascript = true,
			},
		})
	end,
}
