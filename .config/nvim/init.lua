-- set leader key
vim.g.mapleader = " "

_G.Util = require("util")

-- load lua/options.lua, lua/keymaps.lua, and lua/plugin-manager.lua
require("options")
require("keymaps")
require("autocmds")
require("plugin-manager")

-- load lua/settings.lua which contains shared configuration values, including the desired colorscheme
local settings = require("settings")

-- set colorscheme
vim.cmd("colorscheme " .. settings.colorscheme)

vim.cmd([[highlight WinSeparator guifg=#1e222a guibg=NONE]])
vim.cmd([[highlight NvimTreeNormal guibg=#1c2028]])
