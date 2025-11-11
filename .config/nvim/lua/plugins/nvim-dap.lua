return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"theHamsta/nvim-dap-virtual-text",
		"nvim-neotest/nvim-nio",
		"mxsdev/nvim-dap-vscode-js",
	},
	keys = {
		{ "<leader>db", "<cmd>DapToggleBreakpoint<cr>", desc = "Toggle Breakpoint" },
		{ "<leader>dc", "<cmd>DapContinue<cr>", desc = "Continue" },
		{ "<leader>di", "<cmd>DapStepInto<cr>", desc = "Step Into" },
		{ "<leader>do", "<cmd>DapStepOver<cr>", desc = "Step Over" },
		{ "<leader>dO", "<cmd>DapStepOut<cr>", desc = "Step Out" },
		{ "<leader>dr", "<cmd>DapReplToggle<cr>", desc = "Toggle REPL" },
		{ "<leader>dt", "<cmd>DapTerminate<cr>", desc = "Terminate" },
		{ "<leader>du", "<cmd>lua require('dapui').toggle()<cr>", desc = "Toggle UI" },
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		dapui.setup()
		require("nvim-dap-virtual-text").setup()
		require("dap-vscode-js").setup({
			debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
			adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
		})

		-- TypeScript/JavaScript debug configurations
		for _, language in ipairs({ "typescript", "javascript" }) do
			dap.configurations[language] = {
				{
					type = "pwa-node",
					request = "launch",
					name = "Launch file",
					program = "${file}",
					cwd = "${workspaceFolder}",
				},
				{
					type = "pwa-node",
					request = "attach",
					name = "Attach",
					processId = require("dap.utils").pick_process,
					cwd = "${workspaceFolder}",
				},
			}
		end

		-- Auto open/close DAP UI
		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated["dapui_config"] = function()
			dapui.close()
		end
		dap.listeners.before.event_exited["dapui_config"] = function()
			dapui.close()
		end
	end,
}
