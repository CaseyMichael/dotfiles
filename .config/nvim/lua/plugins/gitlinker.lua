return {
	"linrongbin16/gitlinker.nvim",
	cmd = "GitLink",
	opts = {},
	keys = {
		{ "<leader>gy", "<cmd>GitLink<cr>", mode = { "n", "v" }, desc = "Git Yank link" },
		{ "<leader>gY", "<cmd>GitLink default_branch<cr>", mode = { "n", "v" }, desc = "Git Yank link (main)" },
		{ "<leader>go", "<cmd>GitLink!<cr>", mode = { "n", "v" }, desc = "Git Open link" },
		{ "<leader>gO", "<cmd>GitLink! default_branch<cr>", mode = { "n", "v" }, desc = "Git Open link (main)" },
	},
}
