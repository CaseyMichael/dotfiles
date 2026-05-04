return {
	"neovim/nvim-lspconfig",
	enabled = true,
	opts = {
		servers = {
			-- vtsls = false, -- Uncomment to disable vtsls in favor of tsgo
			vtsls = {
				settings = {
					typescript = {
						tsserver = {
							maxTsServerMemory = 16384,
						},
					},
				},
			},
		},
	},
	keys = {
		-- Keep hover and signature help as global keymaps (useful everywhere)
		{ "K", vim.lsp.buf.hover, desc = "Show hover documentation" },
		{ "<C-k>", vim.lsp.buf.signature_help, desc = "Show signature help", mode = { "n", "i" } },
		-- Diagnostic keymaps (global, work everywhere)
		{ "[d", vim.diagnostic.goto_prev, desc = "Previous diagnostic" },
		{ "]d", vim.diagnostic.goto_next, desc = "Next diagnostic" },
		{ "<leader>q", vim.diagnostic.setloclist, desc = "Diagnostics to location list" },
	},
}
