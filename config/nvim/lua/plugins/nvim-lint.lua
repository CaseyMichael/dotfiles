-- Use opts, not config: LazyVim's own config adds debouncing, fallback/global
-- linters and missing-linter warnings, and a `config` function here would
-- replace all of that plus LazyVim's own linters_by_ft entries.
return {
	"mfussenegger/nvim-lint",
	opts = {
		linters_by_ft = {
			-- No lua linter: mason's luacheck crashes under its bundled Lua 5.5,
			-- and lua-language-server already reports diagnostics.
			json = { "jsonlint" },
			yaml = { "yamllint" },
		},
	},
}
