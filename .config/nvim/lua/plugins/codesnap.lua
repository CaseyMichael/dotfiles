return {
	"mistricky/codesnap.nvim",
	tag = "v2.0.0-beta.17",
	config = function()
		require("codesnap").setup({
			snapshot_config = {
				watermark = {
					content = "",
				},
				background = "#00000000",
			},
		})

		vim.keymap.set("v", "<leader>pc", "<cmd>CodeSnap<cr>", { desc = "[P]icture [c]lipboard" })

		vim.keymap.set("v", "<leader>ps", function()
			local filename = string.format("codesnap-%s.png", os.date("%Y-%m-%d_%H-%M-%S"))
			local path = string.format("%s/Pictures/codesnap/%s", vim.fn.expand("~"), filename)
			vim.fn.mkdir(string.format("%s/Pictures/codesnap", vim.fn.expand("~")), "p")
			vim.cmd(string.format("CodeSnapSave %s", path))
		end, { desc = "[P]icture [s]ave" })

		vim.keymap.set("v", "<leader>pa", "<cmd>CodeSnapASCII<cr>", { desc = "[P]icture [a]scii" })
		vim.keymap.set("v", "<leader>ph", "<cmd>CodeSnapHighlight<cr>", { desc = "[P]icture [h]ighlight" })
	end,
}
