return {
	"CaseyMichael/telescope-pnpm-monorepo.nvim",
	-- Local dev: point at the feature/weaver-modules worktree
	dir = "~/Developer/telescope-pnpm-monorepo.nvim/.worktrees/weaver-modules",
	-- silent/autoload_telescope were already the plugin defaults, and data_path
	-- is not an option the plugin reads.
	opts = {},
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
