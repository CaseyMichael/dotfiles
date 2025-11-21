return {
	"CaseyMichael/telescope-pnpm-monorepo.nvim",
	dir = "~/Developer/telescope-pnpm-monorepo.nvim",
	enabled = true,
	-- TODO: Refactor this to work with the opts with lazyvim
	-- opts = {
	--   slient = false,
	--   autoload_telescope = true,
	--   data_path = vim.fn.stdpath("data")
	-- }
	config = function()
		require("pnpm_monorepo").setup({
			silent = false, -- Show vim.notify messages
			autoload_telescope = true, -- Automatically load telescope extension
			data_path = vim.fn.stdpath("data"), -- Where to save monorepo.json
		})
		-- Set up keybinds as shown in the documentation
		vim.keymap.set("n", "<leader>m", function()
			require("telescope").extensions.pnpm_monorepo.pnpm_monorepo()
		end, { desc = "Open monorepo projects" })
	end,
	dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
}
