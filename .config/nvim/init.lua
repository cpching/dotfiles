-- set leader key
vim.g.mapleader = ';'

-- load lua/options.lua, lua/keymaps.lua, and lua/plugin-manager.lua
require("options")
require("keymaps")
require("plugin-manager")

-- load lua/settings.lua which contains shared configuration values, including the desired colorscheme
local settings = require("settings")

-- set colorscheme
vim.cmd('colorscheme ' .. settings.colorscheme)

-- restore cursor position
if vim.fn.has("autocmd") then
    vim.cmd([[ au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif ]])
end
