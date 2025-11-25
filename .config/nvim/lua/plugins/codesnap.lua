return {
	"mistricky/codesnap.nvim",
	tag = "v2.0.0-beta.17",
	opts = {},
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
