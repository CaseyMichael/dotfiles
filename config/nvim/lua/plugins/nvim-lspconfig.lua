return {
	"neovim/nvim-lspconfig",
	init = function()
		-- lattice: pnpm doesn't hoist eslint-plugin-no-only-tests, so eslint-lsp can't resolve it
		local plugins = vim.fn.expand("~/Developer/lattice/packages/eslint-config/node_modules")
		vim.env.NODE_PATH = vim.env.NODE_PATH and (vim.env.NODE_PATH .. ":" .. plugins) or plugins
	end,
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
