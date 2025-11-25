return {
	"neovim/nvim-lspconfig",
	opts = {
		servers = {
			vtsls = false, -- Disable vtsls in favor of tsgo
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
