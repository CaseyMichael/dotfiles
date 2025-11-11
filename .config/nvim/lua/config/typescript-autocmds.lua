-- Auto-format on save for TypeScript
vim.api.nvim_create_autocmd("BufWritePre", {
	group = vim.api.nvim_create_augroup("TypeScriptFormat", { clear = true }),
	pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
	callback = function()
		vim.lsp.buf.format({ async = false })
	end,
})

-- Auto-organize imports on save (optional - can be disabled)
-- vim.api.nvim_create_autocmd("BufWritePre", {
-- 	group = vim.api.nvim_create_augroup("TypeScriptOrganizeImports", { clear = true }),
-- 	pattern = { "*.ts", "*.tsx" },
-- 	callback = function()
-- 		vim.lsp.buf.execute_command({
-- 			command = "_typescript.organizeImports",
-- 			arguments = { vim.api.nvim_buf_get_name(0) },
-- 		})
-- 	end,
-- })

