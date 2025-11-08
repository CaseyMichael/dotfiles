return {
	-- Alternative: Tokyo Night theme (commented out)
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
		config = function()
			vim.cmd([[colorscheme tokyonight]])
		end,
	},

	-- Snacks UI components and utilities (LazyVim defaults)
	{
		"folke/snacks.nvim",
		enabled = true,
		opts = {
			image = { enabled = true },
			statuscolumn = { enabled = true },
			explorer = {
				keys = {
					Y = function(self)
						local node = self:get_node()
						if node and node.path then
							local relative_path = vim.fn.fnamemodify(node.path, ":t")
							vim.fn.setreg("+", relative_path)
							vim.notify('Copied "' .. relative_path .. '" to clipboard', vim.log.levels.INFO)
						end
					end,
				},
			},
		},
	},
	
	-- Lualine the statusline at the bottom of the screen
	{
		"nvim-lualine/lualine.nvim",
		enabled = true,
		opts = {
			options = {
				theme = "auto", -- Auto-detects colorscheme
			},
			sections = {
				lualine_c = {
					{
						"filename",
						path = 1, -- 0: just filename, 1: relative path, 2: absolute path
					},
				},
			},
		},
	},

	-- Bufferline
	{
		"akinsho/bufferline.nvim",
		opts = {
			options = {
				always_show_bufferline = true,
			}
		}
	}
}
