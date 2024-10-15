local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap
-- Function to close buffer or window --
function Close_buffer_or_window()
	vim.api.nvim_command("bn!")
	local success = pcall(vim.api.nvim_command, "bd#")
	if not success then
		print(#vim.api.nvim_list_wins())
		vim.api.nvim_command("q")
	end
end

-- Function to close buffer or window --

-- Fix the paste when enter "p" into insert node
vim.keymap.set("v", "p", function()
	if require("luasnip").in_snippet() then
		vim.api.nvim_feedkeys("p", "n", false)
	else
		vim.api.nvim_feedkeys('"_dP', "n", false)
	end
end, opts)
--

------- ----- ----- ----- ----- ----- ----- ----- ----- ----- Normal ----- ----- ----- ----- ----- ------ ----- ----- ----- -----
keymap("n", "<C-L>", ":update<CR>", opts)
keymap("n", "<C-N>", "<CMD>BufferLineCycleNext<CR>", opts)
keymap("n", "<C-P>", "<CMD>BufferLineCyclePrev<CR>", opts)
keymap("n", "<M-n>", "<CMD>BufferLineMoveNext<CR>", opts)
keymap("n", "<M-p>", "<CMD>BufferLineMovePrev<CR>", opts)
keymap("n", "<C-\\>", "<CMD>lua Close_buffer_or_window()<CR>", opts)
keymap("n", "<UP>", "g<UP>", opts)
keymap("n", "<DOWN>", "g<DOWN>", opts)
keymap("n", ".", ':exe "normal a".nr2char(getchar())<CR>', opts) -- Insert a char after the current char
keymap("n", "<M-.>", ':exe "normal i".nr2char(getchar())<CR>', opts) -- Insert a char before the current char
keymap("n", "<M-o>", 'o<Esc>0"_D', opts) -- Insert a new line before the line
keymap("n", "<M-O>", 'O<Esc>0"_D', opts) -- Insert a new line before the line
keymap("n", "<M-j>", ":m .+1<CR>==", opts) -- Move text down
keymap("n", "<M-k>", ":m .-2<CR>==", opts) -- Move text up
keymap("n", "<M-v>", "<CMD>set paste<CR>i<C-R>+<C-O><CMD>set paste!<CR><ESC>", opts)
keymap("n", "<C-U>", "<C-U>zz", opts)
keymap("n", "<C-D>", "<C-D>zz", opts)
------- ----- ----- ----- ----- ----- ----- ----- ----- ----- Normal ----- ----- ----- ----- ----- ------ ----- ----- ----- -----

------- ----- ----- ----- ----- ----- ----- ----- ----- ----- INSERT ----- ----- ----- ----- ----- ------ ----- ----- ----- -----
keymap("i", "jj", "<ESC>", opts)
keymap("i", "<C-V>", "<C-O><CMD>set paste<CR><C-R>+<C-O><CMD>set paste!<CR>", opts)
keymap("i", "<C-L>", "<C-O>:update<CR>", opts)
keymap("i", "<UP>", "<C-O>g<UP>", opts)
keymap("i", "<DOWN>", "<C-O>g<DOWN>", opts)
------- ----- ----- ----- ----- ----- ----- ----- ----- ----- INSERT ----- ----- ----- ----- ----- ------ ----- ----- ----- -----

------ ----- ----- ----- ----- ------ ----- ----- ----- ----- VISUAL ----- ----- ----- ----- ----- ------ ----- ----- ----- -----
keymap("v", "aa", "<ESC>", opts)
keymap("v", "<C-L>", "<C-C>:update<CR>", opts)
keymap("v", "<M-j>", ":m .+1<CR>==", opts) -- Move text down
keymap("v", "<M-k>", ":m .-2<CR>==", opts) -- Move text up
------ ----- ----- ----- ----- ------ ----- ----- ----- ----- VISUAL ----- ----- ----- ----- ----- ------ ----- ----- ----- -----

------ ----- ----- ----- ----- ------ ----- ----- ----- -- VISUAL BLOCK -- ----- ----- ----- ----- ------ ----- ----- ----- -----
keymap("x", "J", ":move '>+1<CR>gv-gv", opts) -- Move text down
keymap("x", "K", ":move '<-2<CR>gv-gv", opts) -- Move text up
keymap("x", "<M-j>", ":move '>+1<CR>gv-gv", opts) -- Move text down
keymap("x", "<M-k>", ":move '<-2<CR>gv-gv", opts) -- Move text up
------ ----- ----- ----- ----- ------ ----- ----- ----- -- VISUAL BLOCK -- ----- ----- ----- ----- ------ ----- ----- ----- -----
