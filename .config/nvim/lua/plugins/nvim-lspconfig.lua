return {
	"neovim/nvim-lspconfig",
	enabled = true,
	priority = 1000, -- Load before LazyVim's default lspconfig config
	dependencies = {
		"b0o/SchemaStore.nvim", -- Ensure schemastore loads before lspconfig
	},
	opts = {
		-- Global LSP settings
		servers = {
			vtsls = false, -- Disable vtsls in favor of tsgo
		},
	},
	config = function(_, opts)
		local lspconfig = require("lspconfig")
		
		-- Register tsgo IMMEDIATELY, before anything else
		-- This must happen before LazyVim processes opts.servers
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
		-- Use dofile to load from lsp/ directory since it's not in Lua path
		local jsonls_path = vim.fn.stdpath("config") .. "/lsp/jsonls.lua"
		if vim.fn.filereadable(jsonls_path) == 1 then
			local ok, jsonls_config = pcall(dofile, jsonls_path)
			if ok and jsonls_config then
				lspconfig.jsonls.setup(jsonls_config)
			end
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
		local lua_ls_path = vim.fn.stdpath("config") .. "/lsp/lua_ls.lua"
		if vim.fn.filereadable(lua_ls_path) == 1 then
			local ok, lua_ls_config = pcall(dofile, lua_ls_path)
			if ok and lua_ls_config then
				lspconfig.lua_ls.setup(lua_ls_config)
			end
		end
		
		-- Load tsgo config (TypeScript/JavaScript)
		-- Note: tsgo.lua may return nil if no project root is found, which is OK
		local tsgo_path = vim.fn.stdpath("config") .. "/lsp/tsgo.lua"
		if vim.fn.filereadable(tsgo_path) == 1 then
			local ok, tsgo_config = pcall(dofile, tsgo_path)
			if ok and tsgo_config then
				lspconfig.tsgo.setup(tsgo_config)
			end
		end
	end,
}
