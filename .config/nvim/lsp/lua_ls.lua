--- Lua Language Server configuration
---@type vim.lsp.Config
return {
	settings = {
		Lua = {
			completion = {
				callSnippet = "Replace",
			},
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
				},
			},
			-- Additional useful settings
			telemetry = {
				enable = false,
			},
			hint = {
				enable = true, -- Enable inlay hints
				arrayIndex = "Disable",
				setType = true,
			},
		},
	},
}

