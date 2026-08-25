return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	opts = {
		ensure_installed = {
			"bash-language-server",
			"css-variables-language-server",
			"docker-compose-language-service",
			"dockerfile-language-server",
			"eslint-lsp",
			"eslint_d",
			"hadolint",
			"json-lsp",
			"jsonlint", -- used by nvim-lint.lua
			"luacheck", -- used by nvim-lint.lua
			"lua-language-server",
			"markdown-toc",
			"markdownlint-cli2",
			"marksman",
			"prettier",
			"prettierd",
			"rescript-language-server",
			"shellcheck",
			"shfmt",
			"sqlfluff",
			"stylelint-language-server",
			"stylua",
			"taplo",
			"terraform-ls",
			"tflint",
			"tree-sitter-cli",
			-- tsc (TypeScript 7 LSP) is installed via nvim-lspconfig.lua servers.tsc
			"yaml-language-server",
			"yamllint", -- used by nvim-lint.lua
		},
	},
}
