return {
	-- Linting with nvim-lint
	{
		"mfussenegger/nvim-lint",
		event = "BufWritePost",
		config = function()
			require("lint").linters_by_ft = {
				javascript = { "eslint" },
				typescript = { "eslint" },
				lua = { "luacheck" },
				json = { "jsonlint" },
				yaml = { "yamllint" },
			}
			vim.api.nvim_create_autocmd({ "BufWritePost" }, {
				callback = function()
					require("lint").try_lint()
				end,
			})
		end,
	},

	-- Emoji completion
	{
		"hrsh7th/nvim-cmp",
		dependencies = { "hrsh7th/cmp-emoji" },
		---@param opts cmp.ConfigSchema
		opts = function(_, opts)
		  table.insert(opts.sources, { name = "emoji" })
		end,
	}
}
