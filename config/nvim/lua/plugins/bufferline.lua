return {
	"akinsho/bufferline.nvim",
	keys = {
		-- Buffer navigation
		{ "<Tab>", ":bnext<CR>", desc = "Cycle to next buffer", silent = true },
		{ "<S-Tab>", ":bprevious<CR>", desc = "Cycle to previous buffer", silent = true },
		-- Reclaim H/L as screen motions. These must live here, not in
		-- config/keymaps.lua, to win against LazyVim's <S-h>/<S-l> buffer cycling.
		{ "H", "H", desc = "Move to top of screen" },
		{ "L", "L", desc = "Move to bottom of screen" },
	},
}
