return {
	"akinsho/bufferline.nvim",
	enabled = true,
	opts = {},
	keys = {
		-- Buffer navigation
		{ "<Tab>", ":bnext<CR>", desc = "Cycle to next buffer", silent = true },
		{ "<S-Tab>", ":bprevious<CR>", desc = "Cycle to previous buffer", silent = true },
	},
}
