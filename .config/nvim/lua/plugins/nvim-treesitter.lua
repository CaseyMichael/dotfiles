return {
	"nvim-treesitter/nvim-treesitter",
	opts = function(_, opts)
		-- Ensure GraphQL parser is installed
		opts.ensure_installed = opts.ensure_installed or {}
		vim.list_extend(opts.ensure_installed, {
			"graphql",
			"typescript",
			"tsx",
			"javascript",
		})

		-- Enable additional features
		opts.highlight = opts.highlight or {}
		opts.highlight.enable = true
		opts.highlight.additional_vim_regex_highlighting = false

		-- Enable indentation
		opts.indent = opts.indent or {}
		opts.indent.enable = true

		-- Incremental selection
		opts.incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "<C-space>",
				node_incremental = "<C-space>",
				scope_incremental = false,
				node_decremental = "<bs>",
			},
		}
	end,
}
