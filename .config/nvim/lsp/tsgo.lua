--- https://gist.github.com/kr-alt/24aaf4bad50d603c3c6a270502e57209
--- Enhanced tsgo configuration with full TypeScript LSP features

-- Find project root directory
local root_files = {
	"tsconfig.base.json",
	"tsconfig.json",
	"jsconfig.json",
	"package.json",
	".git",
}
local paths = vim.fs.find(root_files, { stop = vim.env.HOME })
local root_dir = vim.fs.dirname(paths[1])

-- Root directory was not found
if root_dir == nil then
	return
end

-- Prepare capabilities with UTF-16 encoding and code lens support
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.general = capabilities.general or {}
capabilities.general.positionEncodings = { "utf-16" }
capabilities.textDocument.codeLens = {
	dynamicRegistration = false,
}

-- Find tsgo binary in PATH or common locations
local function find_tsgo()
	local paths = {
		vim.fn.exepath("tsgo"), -- Check PATH first
		"/opt/homebrew/bin/tsgo", -- Homebrew on Apple Silicon
		"/usr/local/bin/tsgo", -- Homebrew on Intel Mac
		"/usr/bin/tsgo", -- System-wide
	}
	
	for _, path in ipairs(paths) do
		if path and path ~= "" and vim.fn.executable(path) == 1 then
			return path
		end
	end
	
	-- Fallback to PATH (vim.fn.exepath will return empty if not found, but cmd will still try)
	return "tsgo"
end

---@type vim.lsp.Config
return {
	cmd = {
		find_tsgo(),
		"lsp",
		"--stdio",
	},

	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
	},

	root_dir = root_dir,

	-- Set position encoding to UTF-16 to match eslint and avoid encoding conflicts
	-- Merge with default capabilities instead of overwriting them
	capabilities = capabilities,

	-- TypeScript-specific settings for enhanced features
	settings = {
		typescript = {
			inlayHints = {
				includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all'
				includeInlayParameterNameHintsWhenArgumentMatchesName = false,
				includeInlayFunctionParameterTypeHints = true,
				includeInlayVariableTypeHints = true,
				includeInlayVariableTypeHintsWhenTypeMatchesName = false,
				includeInlayPropertyDeclarationTypeHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
				includeInlayEnumMemberValueHints = true,
			},
			suggest = {
				completeFunctionCalls = true, -- Auto-complete function parameters
			},
			-- Improve performance for large codebases
			preferences = {
				disableSuggestions = false,
				quotePreference = "auto",
				importModuleSpecifierPreference = "shortest",
				importModuleSpecifierEnding = "auto",
			},
		},
		javascript = {
			inlayHints = {
				includeInlayParameterNameHints = "all",
				includeInlayParameterNameHintsWhenArgumentMatchesName = false,
				includeInlayFunctionParameterTypeHints = true,
				includeInlayVariableTypeHints = true,
				includeInlayVariableTypeHintsWhenTypeMatchesName = false,
				includeInlayPropertyDeclarationTypeHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
				includeInlayEnumMemberValueHints = true,
			},
			suggest = {
				completeFunctionCalls = true,
			},
			preferences = {
				disableSuggestions = false,
				quotePreference = "auto",
				importModuleSpecifierPreference = "shortest",
				importModuleSpecifierEnding = "auto",
			},
		},
	},

	-- Initialization options for workspace configuration
	init_options = {
		preferences = {
			disableSuggestions = false,
		},
	},

	-- TypeScript-specific on_attach handler
	on_attach = function(client, bufnr)
		-- Enable inlay hints if supported
		if client.server_capabilities.inlayHintProvider then
			vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
		end

		-- Set up TypeScript-specific keybindings
		local opts = { buffer = bufnr, silent = true }

		-- Organize imports
		vim.keymap.set("n", "<leader>co", function()
			vim.lsp.buf.execute_command({
				command = "_typescript.organizeImports",
				arguments = { vim.api.nvim_buf_get_name(0) },
			})
		end, vim.tbl_extend("force", opts, { desc = "Organize Imports" }))

		-- Remove unused imports
		vim.keymap.set("n", "<leader>cR", function()
			vim.lsp.buf.execute_command({
				command = "_typescript.removeUnusedImports",
				arguments = { vim.api.nvim_buf_get_name(0) },
			})
		end, vim.tbl_extend("force", opts, { desc = "Remove Unused Imports" }))

		-- Go to source definition (useful for .d.ts navigation)
		vim.keymap.set("n", "<leader>cD", function()
			vim.lsp.buf.execute_command({
				command = "typescript.goToSourceDefinition",
				arguments = { vim.api.nvim_buf_get_name(0), vim.lsp.util.make_position_params().position },
			})
		end, vim.tbl_extend("force", opts, { desc = "Go to Source Definition" }))

		-- Add missing imports
		vim.keymap.set("n", "<leader>cA", function()
			vim.lsp.buf.code_action({
				apply = true,
				context = {
					only = { "source.addMissingImports.ts" },
					diagnostics = {},
				},
			})
		end, vim.tbl_extend("force", opts, { desc = "Add Missing Imports" }))

		-- Fix all fixable errors
		vim.keymap.set("n", "<leader>cF", function()
			vim.lsp.buf.code_action({
				apply = true,
				context = {
					only = { "source.fixAll.ts" },
					diagnostics = {},
				},
			})
		end, vim.tbl_extend("force", opts, { desc = "Fix All" }))
	end,

	-- Flags for better performance with large monorepos
	flags = {
		debounce_text_changes = 150,
		allow_incremental_sync = true,
	},

	-- Single file support (important for monorepos)
	single_file_support = true,
}
