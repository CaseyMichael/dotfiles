return {
	"nvim-mini/mini.surround",
	config = function()
		require("mini.surround").setup()
		vim.keymap.set("n", "s", "<Nop>", { desc = "Disable default s behavior" })
	end,
}
