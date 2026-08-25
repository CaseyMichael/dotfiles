-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Diagnostic configuration (similar to kickstart.nvim)
-- See :help vim.diagnostic.Opts
vim.diagnostic.config({
	severity_sort = true,
	float = {
		border = "rounded",
		source = "if_many",
	},
	underline = {
		severity = vim.diagnostic.severity.ERROR,
	},
	virtual_text = {
		source = "if_many",
		spacing = 2,
		format = function(diagnostic)
			return diagnostic.message
		end,
	},
})

-- Buffer-local LSP keymaps, using kickstart.nvim bindings with Telescope for
-- navigation. Document highlighting and the inlay-hint toggle used to live here
-- too; Snacks.words already does the former and LazyVim maps <leader>uh for the
-- latter.
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
	callback = function(event)
		local map = function(keys, func, desc, mode)
			vim.keymap.set(mode or "n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end
		local telescope = require("telescope.builtin")

		map("gn", vim.lsp.buf.rename, "[R]e[n]ame")
		map("ga", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
		map("gR", telescope.lsp_references, "[G]oto [R]eferences")
		map("gi", telescope.lsp_implementations, "[G]oto [I]mplementation")
		map("gd", telescope.lsp_definitions, "[G]oto [D]efinition")
		-- WARN: Goto Declaration, not Goto Definition. In C this is the header.
		map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
		map("gO", telescope.lsp_document_symbols, "Open Document Symbols")
		map("gW", telescope.lsp_dynamic_workspace_symbols, "Open Workspace Symbols")
		map("gt", telescope.lsp_type_definitions, "[G]oto [T]ype Definition")
	end,
})
