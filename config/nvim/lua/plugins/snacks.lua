return {
	"folke/snacks.nvim",
	enabled = true,
	opts = {
		image = { enabled = true },
		statuscolumn = { enabled = true },
		picker = {
			sources = {
				explorer = {
					hidden = true,
				},
			},
		},
	},
	keys = {
		{
			"<leader>e",
			function()
				Snacks.explorer()
			end,
			desc = "Explorer Snacks (cwd)",
		},
		{
			"<leader>E",
			function()
				Snacks.explorer({ cwd = LazyVim.root() })
			end,
			desc = "Explorer Snacks (Root Dir)",
		},
	},
}
