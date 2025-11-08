return {
	-- Session management
	{
		"rmagatti/auto-session",
		opts = {
			log_level = "error",
			auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
			auto_session_use_git_branch = true,
			auto_session_enable_last_session = false, -- Disable automatic session restore
			auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/",
			auto_session_enabled = true,
			auto_save_enabled = nil,
			auto_restore_enabled = nil,
			auto_session_create_enabled = nil,
		},
	},

	-- Enhanced window splitting and navigation
	{
		"mrjones2014/smart-splits.nvim",
		enabled = true,
		-- LazyVim provides default configuration for smart-splits
	},

	-- Buffer cycling with Tab/Shift+Tab and restore H/L to original Vim motions
	{
		"nvim-lua/plenary.nvim", -- Ensure plenary is available
		event = "VeryLazy", -- Ensure this loads after LazyVim's defaults
		config = function()
			-- Tab to cycle forward through buffers
			vim.keymap.set("n", "<Tab>", ":bnext<CR>", { desc = "Cycle to next buffer", silent = true })

			-- Shift+Tab to cycle backward through buffers
			vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", { desc = "Cycle to previous buffer", silent = true })

			-- Restore H and L to original Vim screen motions (disable LazyVim's buffer navigation)
			vim.keymap.set("n", "H", function()
				vim.cmd("normal! H")
			end, { desc = "Move to top of screen", silent = true })
			vim.keymap.set("n", "L", function()
				vim.cmd("normal! L")
			end, { desc = "Move to bottom of screen", silent = true })
		end,
	},

	-- Mini.surround for surrounding text with quotes, brackets, etc.
	{
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
		config = function(_, opts)
			require("mini.surround").setup(opts)
			-- Disable default Vim "s" behavior to avoid conflicts with mini.surround
			vim.keymap.set("n", "s", "<Nop>", { desc = "Disable default s behavior" })
		end,
	},

	-- Flash.nvim - disable "s" keybinding
	{
		"folke/flash.nvim",
		enabled = false,
	},

	{
		"nvim-telescope/telescope.nvim",
		enabled = true,
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},
	{
		"imNel/monorepo.nvim",
		enabled = true,
		config = function()
			require("monorepo").setup({
				silent = false, -- Show vim.notify messages
				autoload_telescope = true, -- Automatically load telescope extension
				data_path = vim.fn.stdpath("data"), -- Where to save monorepo.json
			})
			-- Set up keybinds as shown in the documentation
			vim.keymap.set("n", "<leader>mm", function()
				require("telescope").extensions.monorepo.monorepo()
			end, { desc = "Open monorepo projects" })
			vim.keymap.set("n", "<leader>mt", function()
				require("monorepo").toggle_project()
			end, { desc = "Toggle monorepo project" })
		end,
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
	},
	{
		"m-jovan/telescope-pnpm-workspace.nvim",
	},
	{
		"obsidian-nvim/obsidian.nvim",
		version = "*", -- recommended, use latest release instead of latest commit
		ft = "markdown",
		cmd = {
			"ObsidianOpen",
			"ObsidianNew",
			"ObsidianSearch",
			"ObsidianQuickSwitch",
			"ObsidianToday",
			"ObsidianTomorrow",
			"ObsidianYesterday",
			"ObsidianTemplate",
			"ObsidianWorkspace",
			"ObsidianLink",
		},
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			workspaces = {
				{
					name = "work",
					path = "~/Github/obsidian",
				},
			},
			completion = {
				nvim_cmp = true,
				min_chars = 2,
			},
			daily_notes = {
				folder = "Daily",
				template = "daily note",
			},
			templates = {
				folder = "Templates",
				date_format = "%Y-%m-%d-%a",
				time_format = "%H:%M",
			},
		},
	},
}
