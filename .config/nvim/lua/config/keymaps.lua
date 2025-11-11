-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- 

vim.keymap.set('n', '<leader>fp', function() require('telescope').extensions.pnpm_workspace.find_packages() end, { desc = 'Find pnpm packages' })

vim.keymap.set("n", "<leader>fy", function()
    local filename = vim.fn.expand('%:t')
    vim.fn.setreg("+", filename) -- Yank the relative path to the system clipboard
    print("Yanked relative path: " .. filename)
  end, { desc = "Yank file name" })

-- Buffer navigation
vim.keymap.set("n", "<Tab>", ":bnext<CR>", { desc = "Cycle to next buffer", silent = true })
vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", { desc = "Cycle to previous buffer", silent = true })

-- Restore H and L to original Vim screen motions (disable LazyVim's buffer navigation)
vim.keymap.set("n", "H", function()
    vim.cmd("normal! H")
end, { desc = "Move to top of screen", silent = true })
vim.keymap.set("n", "L", function()
    vim.cmd("normal! L")
end, { desc = "Move to bottom of screen", silent = true })