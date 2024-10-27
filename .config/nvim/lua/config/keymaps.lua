local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap
-- Function to close buffer or window --
function Close_buffer_or_window()
	vim.api.nvim_command("bn!")
	local success = pcall(vim.api.nvim_command, "bd#")
	if not success then
		-- print(#vim.api.nvim_list_wins())
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

-- Function to delete a specific mark
function DeleteMark()
	print("Press a mark key to delete")

	-- Get a single character from the user
	local char = vim.fn.getchar()

	-- Convert the character to a string
	local key = vim.fn.nr2char(char)

	-- Delete the specified mark
	vim.cmd("delmarks " .. key)
	print("Deleted mark `" .. key .. "`")
end

------- ----- ----- ----- ----- ----- ----- ----- ----- ----- Normal ----- ----- ----- ----- ----- ------ ----- ----- ----- -----
keymap("n", "<C-L>", ":update<CR>", opts)
keymap("n", "<C-N>", "<CMD>BufferLineCycleNext<CR>", opts)
keymap("n", "<C-P>", "<CMD>BufferLineCyclePrev<CR>", opts)
keymap("n", "<M-n>", "<CMD>BufferLineMoveNext<CR>", opts)
keymap("n", "<M-p>", "<CMD>BufferLineMovePrev<CR>", opts)
keymap("n", "<C-\\>", "<CMD>lua Close_buffer_or_window()<CR>", opts)
keymap("n", "<UP>", "g<UP>", opts)
keymap("n", "<DOWN>", "g<DOWN>", opts)
keymap(
	"n",
	"<leader>a",
	':exe "normal a".nr2char(getchar())<CR>',
	{ desc = "Insert a Char After the Current Char", noremap = true, silent = true }
)
keymap(
	"n",
	"<leader>i",
	':exe "normal i".nr2char(getchar())<CR>',
	{ desc = "Insert a Char Before the Current Char", noremap = true, silent = true }
)
keymap("n", "<M-o>", 'o<Esc>0"_D', opts) -- Insert a new line before the line
keymap("n", "<M-O>", 'O<Esc>0"_D', opts) -- Insert a new line before the line
keymap("n", "<M-j>", ":m .+1<CR>==", opts) -- Move text down
keymap("n", "<M-k>", ":m .-2<CR>==", opts) -- Move text up
keymap("n", "<M-v>", "<CMD>set paste<CR>i<C-R>+<C-O><CMD>set paste!<CR><ESC>", opts)
keymap("n", "<C-U>", "<C-U>zz", opts)
keymap("n", "<C-D>", "<C-D>zz", opts)
keymap("n", "<leader>dm", ":lua DeleteMark()<CR>", { desc = "Delete Following Mark", noremap = true, silent = true })

-- session
keymap("n", "<leader>qq", "<CMD>wqa<CR>", { desc = "Quit All", noremap = true, silent = true })

-- buffer
keymap("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer", noremap = true, silent = true })

-- window
keymap("n", "<leader><tab>", "<c-w>w", { desc = "Windows", noremap = true, silent = true })
keymap("n", "<leader>h", "<c-w>wh", { desc = "Move to Window Left", noremap = true, silent = true })
keymap("n", "<leader>j", "<c-w>wj", { desc = "Move to Window Below", noremap = true, silent = true })
keymap("n", "<leader>k", "<c-w>wk", { desc = "Move to Window Above", noremap = true, silent = true })
keymap("n", "<leader>l", "<c-w>wl", { desc = "Move to Window Right", noremap = true, silent = true })
keymap("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", noremap = true, silent = true })
keymap("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", noremap = true, silent = true })
-- keymap("n", "<leader>w", "<C-W>c", { desc = "Delete Window", noremap = true, silent = true })

-- tabs
keymap("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab", noremap = true, silent = true })
keymap("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs", noremap = true, silent = true })
keymap("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab", noremap = true, silent = true })
keymap("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab", noremap = true, silent = true })
keymap("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab", noremap = true, silent = true })
keymap("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab", noremap = true, silent = true })
keymap("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab", noremap = true, silent = true })

------- ----- ----- ----- ----- ----- ----- ----- ----- ----- Normal ----- ----- ----- ----- ----- ------ ----- ----- ----- -----

------- ----- ----- ----- ----- ----- ----- ----- ----- ----- INSERT ----- ----- ----- ----- ----- ------ ----- ----- ----- -----
keymap("i", "jj", "<ESC>", opts)
keymap("i", "<C-V>", "<C-O><CMD>set paste<CR><C-R>+<C-O><CMD>set paste!<CR>", opts)
keymap("i", "<C-L>", "<C-O>:update<CR>", opts)
keymap("i", "<UP>", "<C-O>g<UP>", opts)
keymap("i", "<DOWN>", "<C-O>g<DOWN>", opts)
keymap("i", "<C-E>", "<C-O>$", { desc = "Jump to End of Line", noremap = true, silent = true })

-- Add undo break-points
keymap("i", ",", ",<c-g>u", opts)
keymap("i", ".", ".<c-g>u", opts)
keymap("i", ";", ";<c-g>u", opts)
------- ----- ----- ----- ----- ----- ----- ----- ----- ----- INSERT ----- ----- ----- ----- ----- ------ ----- ----- ----- -----

------ ----- ----- ----- ----- ------ ----- ----- ----- ----- VISUAL ----- ----- ----- ----- ----- ------ ----- ----- ----- -----
keymap("v", "aa", "<ESC>", opts)
keymap("v", "<C-L>", "<C-C>:update<CR>", opts)
keymap("v", "<M-j>", ":m .+1<CR>==", opts) -- Move text down
keymap("v", "<M-k>", ":m .,-2<CR>==", opts) -- Move text up
------ ----- ----- ----- ----- ------ ----- ----- ----- ----- VISUAL ----- ----- ----- ----- ----- ------ ----- ----- ----- -----

------ ----- ----- ----- ----- ------ ----- ----- ----- -- VISUAL BLOCK -- ----- ----- ----- ----- ------ ----- ----- ----- -----
keymap("x", "J", ":move '>+1<CR>gv-gv", opts) -- Move text down
keymap("x", "K", ":move '<-2<CR>gv-gv", opts) -- Move text up
keymap("x", "<M-j>", ":move '>+1<CR>gv-gv", opts) -- Move text down
keymap("x", "<M-k>", ":move '<-2<CR>gv-gv", opts) -- Move text up
------ ----- ----- ----- ----- ------ ----- ----- ----- -- VISUAL BLOCK -- ----- ----- ----- ----- ------ ----- ----- ----- -----

------ ----- ----- ----- ----- ------ ----- ----- ----- ---- Command ---- ----- ----- ----- ----- ------ ----- ----- ----- -----
------ ----- ----- ----- ----- ------ ----- ----- ----- ---- Command ---- ----- ----- ----- ----- ------ ----- ----- ----- -----
