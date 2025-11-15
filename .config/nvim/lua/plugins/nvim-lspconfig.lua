return {
	"neovim/nvim-lspconfig",
	opts = {
		servers = {
			vtsls = false, -- Disable vtsls in favor of tsgo
		},
	},
	config = function()
		-- Diagnostic configuration (similar to kickstart.nvim)
		-- See :help vim.diagnostic.Opts
		vim.diagnostic.config({
			severity_sort = true,
			float = {
				border = "rounded",
				source = "if_many",
			},
			underline = {
				severity = vim.diagnostic.severity.ERROR,
			},
			virtual_text = {
				source = "if_many",
				spacing = 2,
				format = function(diagnostic)
					return diagnostic.message
				end,
			},
		})
	end,
}

