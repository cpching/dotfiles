-- highlight yank selection
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 300 })
	end,
})

-- restore cursor position
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
	callback = function(event)
		local buf = event.buf
		local exclude = { "gitcommit" }
		if vim.tbl_contains(exclude, vim.bo[buf].filetype) then
			return
		end
		local last_mark = vim.api.nvim_buf_get_mark(buf, '"')
		local line_cnt = vim.api.nvim_buf_line_count(buf)
		if last_mark[1] > 0 and last_mark[1] <= line_cnt then
			pcall(vim.api.nvim_win_set_cursor, 0, last_mark)
		end
	end,
})

vim.api.nvim_create_autocmd("BufEnter", {
	nested = true,
	callback = function()
		if #vim.api.nvim_list_wins() == 1 and require("nvim-tree.utils").is_nvim_tree_buf() then
			vim.cmd("quit")
		end
	end,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
	callback = function()
		vim.cmd("NvimTreeClose")
	end,
})
