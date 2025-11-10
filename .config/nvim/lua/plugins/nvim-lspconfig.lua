return {
	"neovim/nvim-lspconfig",
	enabled = true,
	opts = {
		-- Global LSP settings
		servers = {
			vtsls = false, -- Disable vtsls in favor of tsgo
		},
	},
}
