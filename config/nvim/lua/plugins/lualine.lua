return {
	"nvim-lualine/lualine.nvim",
	enabled = true,
	opts = {
		options = {
			theme = "auto", -- Auto-detects colorscheme
		},
		sections = {
			lualine_c = {
				{
					"filename",
					path = 1, -- 0: just filename, 1: relative path, 2: absolute path
				},
			},
			lualine_z = {},
		},
	},
}
