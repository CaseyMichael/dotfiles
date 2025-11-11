return {
	"nvimdev/lspsaga.nvim",
	enabled = false,
	event = "LspAttach",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		require("lspsaga").setup({
			symbol_in_winbar = {
				enable = true,
				separator = " › ",
				hide_keyword = true,
				show_file = true,
				folder_level = 1,
			},
			-- Prevent multiple simultaneous requests
			definition = {
				keys = {
					edit = "<C-o>",
					vsplit = "<C-v>",
					split = "<C-s>",
					tabe = "<C-t>",
					quit = "q",
					close = "<Esc>",
				},
			},
			-- Add request timeout to prevent hanging requests
			request_timeout = 5000,
		})
		
		-- Handle tsgo and other custom LSP servers that may be slow to initialize
		-- or may not support document symbols
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				local client = vim.lsp.get_client_by_id(args.data.client_id)
				if client and client.name == "tsgo" then
					-- Wait longer for tsgo to initialize and check if it supports symbols
					vim.defer_fn(function()
						local current_client = vim.lsp.get_client_by_id(args.data.client_id)
						if current_client then
							-- If tsgo doesn't support document symbols, disable symbol_in_winbar for this buffer
							if not current_client.server_capabilities.documentSymbolProvider then
								-- Disable symbol_in_winbar for tsgo if it doesn't support symbols
								-- This prevents the error message from appearing
								vim.api.nvim_buf_set_var(args.buf, "lspsaga_symbol_in_winbar", false)
							end
						end
					end, 2000) -- Wait 2 seconds for tsgo to fully initialize
				end
			end,
		})
	end,
	keys = {
		{ "<leader>ca", "<cmd>Lspsaga code_action<cr>", desc = "Code Action" },
		{ "<leader>cd", "<cmd>Lspsaga show_cursor_diagnostics<cr>", desc = "Cursor Diagnostics" },
		{ "]d", "<cmd>Lspsaga diagnostic_jump_next<cr>", desc = "Next Diagnostic" },
		{ "[d", "<cmd>Lspsaga diagnostic_jump_prev<cr>", desc = "Prev Diagnostic" },
		{ "K", "<cmd>Lspsaga hover_doc<cr>", desc = "Hover Doc" },
		{ "<leader>cr", "<cmd>Lspsaga rename<cr>", desc = "Rename" },
		{ "gd", "<cmd>Lspsaga goto_definition<cr>", desc = "Goto Definition" },
		{ "gD", "<cmd>Lspsaga goto_type_definition<cr>", desc = "Goto Type Definition" },
		{ "gr", "<cmd>Lspsaga finder<cr>", desc = "References" },
		{ "<leader>co", "<cmd>Lspsaga outline<cr>", desc = "Outline" },
	},
}
