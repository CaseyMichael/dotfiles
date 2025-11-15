---@type vim.lsp.Config
return {
	cmd = { "tsgo", "--lsp", "--stdio" },
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
	},
	root_dir = function(fname)
		local util = require('lspconfig.util')
		-- Find workspace root by pnpm-workspace.yaml
		return util.root_pattern('pnpm-workspace.yaml', 'pnpm-lock.yaml')(fname)
	end,
	init_options = {
		preferences = {
			includePackageJsonAutoImports = "on",
			resolveSourceFileDefinitions = true,
		},
	},
	settings = {
		typescript = {
			preferences = {
				resolveSourceFileDefinitions = true,
			},
		},
	},
}

