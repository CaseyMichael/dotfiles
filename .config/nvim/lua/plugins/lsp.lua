return {
	-- LSP configuration and enhancements
	{
		"neovim/nvim-lspconfig",
		enabled = true,
		opts = {
			-- Global LSP settings
			servers = {
				vtsls = false, -- Disable vtsls in favor of tsgo
			},
		},
	},

	-- JSON Schema Store for better validation
	{
		"b0o/SchemaStore.nvim",
		-- Provides JSON schemas for better validation
		-- LazyVim will automatically use schemas if available
	},
}

-- Note: Individual LSP configs are in /lsp/*.lua files
-- They are enabled via vim.lsp.enable() in lua/config/autocmds.lua
