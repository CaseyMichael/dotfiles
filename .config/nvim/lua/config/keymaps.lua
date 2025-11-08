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