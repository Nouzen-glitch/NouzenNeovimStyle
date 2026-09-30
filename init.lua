-- Neovim "Elite IDE" configuration
-- See docs/README.md for installation, rationale, and keybinding reference.
--
-- Your own changes go in lua/user/ (gitignored); see docs/MIGRATING.md.

local user = require("util.user")

require("config.options")
user.load("user.options")
require("config.keymaps")
user.load("user.keymaps")
require("config.autocmds")
require("config.lazy")
require("util.cheatsheet").setup()
require("util.lockfile").setup()
require("util.welcome").setup()
