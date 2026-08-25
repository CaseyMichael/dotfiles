-- Use opts, not config: LazyVim's own config adds debouncing, fallback/global
-- linters and missing-linter warnings, and a `config` function here would
-- replace all of that plus LazyVim's own linters_by_ft entries.
return {
	"mfussenegger/nvim-lint",
	opts = {
		linters_by_ft = {
			lua = { "luacheck" },
			json = { "jsonlint" },
			yaml = { "yamllint" },
		},
	},
}
