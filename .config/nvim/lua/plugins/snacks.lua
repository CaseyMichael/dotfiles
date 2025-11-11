return {
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
}
