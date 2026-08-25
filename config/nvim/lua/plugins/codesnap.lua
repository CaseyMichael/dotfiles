return {
	"mistricky/codesnap.nvim",
	tag = "v2.0.0-beta.17",
	opts = {
		snapshot_config = {
			watermark = { content = "" },
			background = "#00000000",
		},
	},
	keys = {
		{ "<leader>pc", "<cmd>CodeSnap<cr>", mode = "x", desc = "[P]icture [c]lipboard" },
		{
			"<leader>ps",
			function()
				local dir = vim.fn.expand("~/Pictures/codesnap")
				vim.fn.mkdir(dir, "p")
				vim.cmd.CodeSnapSave(("%s/codesnap-%s.png"):format(dir, os.date("%Y-%m-%d_%H-%M-%S")))
			end,
			mode = "x",
			desc = "[P]icture [s]ave",
		},
		{ "<leader>pa", "<cmd>CodeSnapASCII<cr>", mode = "x", desc = "[P]icture [a]scii" },
		{ "<leader>ph", "<cmd>CodeSnapHighlight<cr>", mode = "x", desc = "[P]icture [h]ighlight" },
	},
}
