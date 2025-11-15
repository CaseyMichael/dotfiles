return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		"hrsh7th/cmp-emoji",
		-- LazyVim provides these via extras, but being explicit here
		"hrsh7th/cmp-nvim-lsp", -- LSP source
		"hrsh7th/cmp-path", -- Path completion
		"hrsh7th/cmp-buffer", -- Buffer completion
		"saadparwaiz1/cmp_luasnip", -- Snippet source
		"L3MON4D3/LuaSnip", -- Snippet engine
	},
	opts = function(_, opts)
		-- Ensure sources are configured (LazyVim may provide defaults, but being explicit)
		opts.sources = opts.sources or {}
		-- Sources are typically configured by LazyVim, but we can ensure they're present
		-- The actual configuration is handled by LazyVim's nvim-cmp extra
		return opts
	end,
}
