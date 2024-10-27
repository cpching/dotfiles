-- set leader key
vim.g.mapleader = " "

_G.Util = require("util")
_G.Config = require("config")

-- load lua/config/init.lua
-- require("config.keymaps")
-- require("config.autocmds")
-- require("config.options")
require("plugin-manager")

-- load lua/settings.lua which contains shared configuration values, including the desired colorscheme
local settings = Config.settings

-- set colorscheme
vim.cmd("colorscheme " .. settings.colorscheme)

-- vim.cmd([[highlight WinSeparator guifg=#1e222a guibg=NONE]])
-- vim.cmd([[highlight Normal guibg=]])
