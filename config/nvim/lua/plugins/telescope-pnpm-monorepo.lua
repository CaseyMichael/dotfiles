return {
	"CaseyMichael/telescope-pnpm-monorepo.nvim",
	dir = "~/Developer/telescope-pnpm-monorepo.nvim",
	enabled = true,
	opts = {
		slient = false,
		autoload_telescope = true,
		data_path = vim.fn.stdpath("data"),
	},
	dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
	keys = {
		{
			"<leader>m",
			function()
				require("telescope").extensions.pnpm_monorepo.pnpm_monorepo()
			end,
			desc = "Open monorepo projects",
		},
	},
}
