return {
	"nvim-treesitter/nvim-treesitter",
	opts = function(_, opts)
		vim.list_extend(opts.ensure_installed or {}, {
			"graphql",
			"typescript",
			"tsx",
			"javascript",
		})
		opts.textobjects = {
			select = {
				enable = true,
				keymaps = {
					["af"] = "@function.outer",
					["if"] = "@function.inner",
					["ac"] = "@class.outer",
					["ic"] = "@class.inner",
					["aC"] = "@call.outer",
					["iC"] = "@call.inner",
					["aP"] = "@parameter.outer",
					["iP"] = "@parameter.inner",
				},
			},
			move = {
				enable = true,
				goto_next_start = {
					["]f"] = "@function.outer",
					["]c"] = "@class.outer",
					["]C"] = "@call.outer",
					["]p"] = "@parameter.outer",
				},
				goto_previous_start = {
					["[f"] = "@function.outer",
					["[c"] = "@class.outer",
					["[C"] = "@call.outer",
					["[p"] = "@parameter.outer",
				},
			},
			swap = {
				enable = true,
				swap_next = {
					["<leader>sa"] = "@parameter.inner",
				},
				swap_previous = {
					["<leader>sA"] = "@parameter.inner",
				},
			},
		}
	end,
}
