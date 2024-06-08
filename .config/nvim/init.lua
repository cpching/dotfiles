-- leader key setting
vim.g.mapleader = ';'

-- require("options")
-- require("keymaps")
-- require("plugin-manager")

-- vim.cmd[[colorscheme ]]

-- restore cursor position
if vim.fn.has("autocmd") then
    vim.cmd([[ au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif ]])
    end
