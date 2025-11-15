return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		"hrsh7th/cmp-emoji",
		-- LazyVim provides these via extras, but being explicit here
		"hrsh7th/cmp-nvim-lsp", -- LSP source (provides TypeScript completion via tsgo)
		"hrsh7th/cmp-path", -- Path completion
		"hrsh7th/cmp-buffer", -- Buffer completion
		"saadparwaiz1/cmp_luasnip", -- Snippet source
		"L3MON4D3/LuaSnip", -- Snippet engine
	},
	opts = function(_, opts)
		-- LazyVim's nvim-cmp extra should configure sources automatically
		-- But we ensure nvim_lsp source is present for TypeScript/LSP completion
		opts.sources = opts.sources or {
			{ name = "nvim_lsp" }, -- LSP completion (includes TypeScript via tsgo)
			{ name = "path" }, -- Path completion
			{ name = "luasnip" }, -- Snippet completion
		}

		-- Ensure nvim_lsp source is in the sources list if it's not already
		local has_lsp_source = false
		for _, source in ipairs(opts.sources) do
			if source.name == "nvim_lsp" then
				has_lsp_source = true
				break
			end
		end
		if not has_lsp_source then
			table.insert(opts.sources, { name = "nvim_lsp" })
		end

		return opts
	end,
}
