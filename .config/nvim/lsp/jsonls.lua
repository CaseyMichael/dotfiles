--- JSON Language Server configuration with SchemaStore integration
---@type vim.lsp.Config
return {
	settings = {
		json = {
			validate = { enable = true },
			schemas = vim.tbl_deep_extend("force", {}, require("schemastore").json.schemas()),
			format = {
				enable = true,
			},
		},
	},

	-- On attach handler for JSON-specific features
	on_attach = function(client, bufnr)
		-- Enable format on save for JSON files
		if client.server_capabilities.documentFormattingProvider then
			local opts = { buffer = bufnr, silent = true }
			vim.keymap.set("n", "<leader>cf", function()
				vim.lsp.buf.format({ async = false })
			end, vim.tbl_extend("force", opts, { desc = "Format JSON" }))
		end
	end,
}

