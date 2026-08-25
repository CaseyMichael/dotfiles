return {
	"neovim/nvim-lspconfig",
	opts = {
		servers = {
			-- TypeScript 7: `tsc --lsp --stdio`. Replaces the tsgo preview
			-- (npm @typescript/native-preview) and vtsls/tsserver.
			-- LazyVim installs this via mason (package `tsc`) and enables it.
			tsc = {},
			tsgo = false, -- superseded by tsc; mason auto-enables anything installed
			vtsls = false,
		},
	},
	keys = {
		-- K (hover) and <C-k> (signature help) are Neovim defaults, and LazyVim
		-- already maps ]d/[d via vim.diagnostic.jump.
		{ "<leader>q", vim.diagnostic.setloclist, desc = "Diagnostics to location list" },
	},
}
