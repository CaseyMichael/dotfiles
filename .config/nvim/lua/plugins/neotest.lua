return {
	-- test output does not work as expected and causes test
	-- summaries to show the tests failed, but actually passed.
	"nvim-neotest/neotest",
	enabled = false,
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		"marilari88/neotest-vitest",
		"haydenmeade/neotest-jest",
	},
	keys = {
		{ "<leader>tt", function()
			require("neotest").run.run()
		end, desc = "Run Test" },
		{ "<leader>tT", function()
			require("neotest").run.run({ strategy = "dap" })
		end, desc = "Debug Test" },
		{ "<leader>tf", function()
			require("neotest").run.run(vim.fn.expand("%"))
		end, desc = "Run File" },
		{ "<leader>ts", function()
			require("neotest").summary.toggle()
		end, desc = "Test Summary" },
		{ "<leader>to", function()
			require("neotest").output.open({ enter = true })
		end, desc = "Test Output" },
	},
	config = function()
		require("neotest").setup({
			-- Enable debug logging to see what's happening
			log_level = vim.log.levels.DEBUG,
			log_file = vim.fn.stdpath("data") .. "/neotest.log",
			adapters = {
				require("neotest-vitest"),
				require("neotest-jest")({
					-- Find package.json relative to the test file
					cwd = function(path)
						-- Find the nearest package.json starting from the test file's directory
						local current = path or vim.fn.getcwd()
						local package_json = vim.fn.findfile("package.json", current .. ";")
						if package_json ~= "" then
							return vim.fn.fnamemodify(package_json, ":h")
						end
						return current
					end,
					jestCommand = function()
						-- This runs from the cwd set by the cwd function above
						local cwd = vim.fn.getcwd()
						
						-- Check if we're in a pnpm workspace (look for pnpm-workspace.yaml in parent dirs)
						local pnpm_workspace = vim.fn.findfile("pnpm-workspace.yaml", cwd .. ";")
						
						-- Use test:base for pnpm workspaces, otherwise regular test command
						local base_cmd = pnpm_workspace ~= "" and "pnpm test:base --" or "pnpm test --"
						
						-- Unset CI environment variable to prevent DD_API_KEY check
						-- Redirect stderr to /dev/null to filter out development metrics errors
						-- that appear after successful tests but confuse neotest-jest
						return string.format("env -u CI %s 2>/dev/null", base_cmd)
					end,
					jestConfigFile = function(path)
						-- Find jest config relative to the test file's package.json
						local test_dir = path and vim.fn.fnamemodify(path, ":h") or vim.fn.getcwd()
						local package_json = vim.fn.findfile("package.json", test_dir .. ";")
						
						if package_json == "" then
							package_json = vim.fn.findfile("package.json", vim.fn.getcwd() .. ";")
						end
						
						if package_json == "" then
							return nil
						end
						
						local package_dir = vim.fn.fnamemodify(package_json, ":h")
						
						-- Check for common jest config files
						local configs = { "jest.config.ts", "jest.config.js", "jest.config.mjs", "jest.config.json" }
						for _, config in ipairs(configs) do
							local config_path = package_dir .. "/" .. config
							if vim.fn.filereadable(config_path) == 1 then
								-- Return absolute path
								return vim.fn.fnamemodify(config_path, ":p")
							end
						end
						return nil
					end,
					env = function()
						local env = {}
						-- Use os.getenv instead of vim.env to avoid fast event context issues
						if not os.getenv("NODE_ENV") then
							env.NODE_ENV = "test"
						end
						return env
					end,
				}),
			},
		})
	end,
}
