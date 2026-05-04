-- Pull in the wezterm API
local wezterm = require("wezterm")
local theme = wezterm.plugin.require("https://github.com/neapsix/wezterm").main
local config = wezterm.config_builder()
local font_size = 14

-- This will hold the configuration.

-- theme
config.colors = theme.colors()

config.window_frame = theme.window_frame()
config.window_frame.font_size = font_size
config.use_fancy_tab_bar = true

-- This is where you actually apply your config choices.

-- For example, changing the initial geometry for new windows:
config.initial_cols = 100
config.initial_rows = 28

-- or, changing the font size and color scheme.
config.font = wezterm.font("Hack")
config.font_size = font_size
config.default_cwd = "/Users/casey/Developer/lattice"

-- Helper function that loads my zsh profile and zshrc to run commands
local function run(cmd)
	local prefix = [[
    [ -f "$HOME/.zprofile" ] && . "$HOME/.zprofile";
    [ -f "$HOME/.zshrc" ] && . "$HOME/.zshrc";
  ]]
	-- Run the command, don't kill the pane if it fails, then drop into a login zsh
	return { "/bin/zsh", "-lc", prefix .. cmd .. " || true; exec /bin/zsh -l" }
end

-- Helper function that appends clipboard contents to a command
local function appendClipboard(cmd)
	return cmd .. ' "$(pbpaste)"'
end

local my_scripts = {
	{
		label = "bootstrap",
		args = run("pnpm bootstrap"),
	},
	{
		label = "start (auto)",
		args = run("pnpm start -a"),
	},
	{
		label = "time-off check",
		args = run("pnpm -F time-off check"),
	},
	{
		label = "time-off unit tests",
		args = run("pnpm -F time-off test"),
	},
	{
		label = "time-off unit test with clipboard",
		args = run(appendClipboard("pnpm -F time-off test")),
	},
	{
		label = "time-off integration tests",
		args = run("pnpm -F time-off test:rickybobby"),
	},
	{
		label = "time-off integration test",
		args = run(appendClipboard("pnpm -F time-off test:rickybobby")),
	},
	{
		label = "time-off new empty migration",
		args = run(appendClipboard("pnpm -F time-off db:migration:empty")),
	},
}

config.launch_menu = my_scripts

-- custom keybindings
config.keys = {
	{
		key = "s",
		mods = "CMD|SHIFT",
		action = wezterm.action.ShowLauncher,
	},
	{
		key = "A",
		mods = "CMD|SHIFT",
		action = wezterm.action.ActivateCommandPalette,
	},
	{
		key = "w",
		mods = "CTRL|SHIFT",
		action = wezterm.action.CloseCurrentPane({ confirm = false }),
	},
}

-- Finally, return the configuration to wezterm:
return config
