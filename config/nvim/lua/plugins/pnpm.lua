return {
	"lukahartwig/pnpm.nvim",
	enabled = false,
	opts = {},
	requires = {
		{ "nvim-telescope/telescope.nvim" },
	},
	keys = {
		{
			"<leader>fw",
			function()
				require("telescope").extensions.pnpm.workspace()
			end,
			desc = "Open pnpm projects",
		},
	},
}
