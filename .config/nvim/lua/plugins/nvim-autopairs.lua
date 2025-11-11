return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	config = function()
		local npairs = require("nvim-autopairs")
		npairs.setup({})

		-- Integration with nvim-cmp (configured in nvim-cmp.lua)
		-- The cmp integration is handled in nvim-cmp.lua after autopairs is loaded
	end,
}