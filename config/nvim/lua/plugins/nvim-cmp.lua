-- LazyVim's nvim-cmp extra already wires up cmp-nvim-lsp / cmp-buffer /
-- cmp-path / cmp_luasnip, and lazydev.nvim registers its own cmp source.
-- Emoji completion is the only thing not covered.
return {
	"hrsh7th/nvim-cmp",
	dependencies = { "hrsh7th/cmp-emoji" },
	opts = function(_, opts)
		table.insert(opts.sources, { name = "emoji" })
	end,
}
