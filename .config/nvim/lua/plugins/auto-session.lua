return {
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
}
