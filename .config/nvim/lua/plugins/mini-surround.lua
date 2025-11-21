return {
	"nvim-mini/mini.surround",
	opts = {
		-- Customize key mappings
		mappings = {
			add = "sa", -- Add surrounding
			delete = "sd", -- Delete surrounding
			replace = "sr", -- Replace surrounding
			find = "sf", -- Find surrounding (right)
			find_left = "sF", -- Find surrounding (left)
			highlight = "sh", -- Highlight surrounding
			update_n_lines = "sn", -- Update n lines
		},
	},
}
