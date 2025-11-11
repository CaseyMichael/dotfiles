return {
	"stevearc/aerial.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	keys = {
		{ "<leader>cs", "<cmd>AerialToggle<cr>", desc = "Symbols Outline" },
		{ "[[", "<cmd>AerialPrev<cr>", desc = "Prev Symbol" },
		{ "]]", "<cmd>AerialNext<cr>", desc = "Next Symbol" },
	},
	-- Use defaults - no custom opts needed
}
