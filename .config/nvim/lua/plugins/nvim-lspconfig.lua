return {
	"neovim/nvim-lspconfig",
	enabled = false,
	dependencies = {
		"b0o/SchemaStore.nvim", -- Ensure schemastore loads before lspconfig
	},
	opts = {
		-- Global LSP settings
		servers = {
			vtsls = false, -- Disable vtsls in favor of tsgo
		},
	},
	config = function()
		local lspconfig = require("lspconfig")

		-- Register tsgo as a custom server if not already registered
		if not lspconfig.configs.tsgo then
			lspconfig.configs.tsgo = {
				default_config = {
					name = "tsgo",
					cmd = { "tsgo", "lsp", "--stdio" },
					filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
					root_dir = lspconfig.util.root_pattern("tsconfig.json", "jsconfig.json", "package.json", ".git"),
					single_file_support = true,
				},
			}
		end

		-- Load JSON LSP config (includes SchemaStore)
		local jsonls_config = require("lsp.jsonls")
		if jsonls_config then
			lspconfig.jsonls.setup(jsonls_config)
		else
			-- Fallback if lsp/jsonls.lua doesn't exist
			local schemastore_ok, schemastore = pcall(require, "schemastore")
			if schemastore_ok then
				lspconfig.jsonls.setup({
					settings = {
						json = {
							schemas = schemastore.json.schemas(),
							validate = { enable = true },
						},
					},
				})
			end
		end

		-- Load Lua LSP config
		local lua_ls_config = require("lsp.lua_ls")
		if lua_ls_config then
			lspconfig.lua_ls.setup(lua_ls_config)
		end

		-- Load tsgo config (TypeScript/JavaScript)
		-- Note: tsgo.lua may return nil if no project root is found, which is OK
		local tsgo_config_ok, tsgo_config = pcall(require, "lsp.tsgo")
		if tsgo_config_ok and tsgo_config then
			lspconfig.tsgo.setup(tsgo_config)
		end
	end,
}
