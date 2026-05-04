return {
	"mistricky/codesnap.nvim",
	enabled = true,
	tag = "v2.0.0-beta.17",
	opts = {},
	keys = {
		{
			"<leader>pc",
			function()
				vim.cmd("CodeSnap")
			end,
			mode = "x",
			desc = "[P]icture [c]lipboard",
		},
		{
			"<leader>ps",
			function()
				local filename = string.format("codesnap-%s.png", os.date("%Y-%m-%d_%H-%M-%S"))
				local path = string.format("%s/Pictures/codesnap/%s", vim.fn.expand("~"), filename)
				vim.fn.mkdir(string.format("%s/Pictures/codesnap", vim.fn.expand("~")), "p")
				vim.cmd(string.format("CodeSnapSave %s", path))
			end,
			mode = "x",
			desc = "[P]icture [s]ave",
		},
		{ "<leader>pa", "<cmd>CodeSnapASCII<cr>", mode = "x", desc = "[P]icture [a]scii" },
		{ "<leader>ph", "<cmd>CodeSnapHighlight<cr>", mode = "x", desc = "[P]icture [h]ighlight" },
	},
	config = function()
		require("codesnap").setup({
			snapshot_config = {
				watermark = {
					content = "",
				},
				background = "#00000000",
			},
		})
	end,
}
