-- Bootstrap LazyVim. It loads config.options before setup, and
-- config.keymaps / config.autocmds on VeryLazy, so requiring them
-- here would run them too early to override LazyVim's own mappings.
require("config.lazy")
