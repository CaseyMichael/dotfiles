return {
	"neovim/nvim-lspconfig",
	opts = {
		servers = {
			vtsls = false, -- Disable vtsls in favor of tsgo
		},
	},
	config = function()
	end,
}

