local M = setmetatable({}, {
	__call = function(m, ...)
		return m.wrap(...)
	end,
})

M.picker = nil

function M.register(picker)
	-- this only happens when using :LazyExtras
	-- so allow to get the full spec
	if vim.v.vim_did_enter == 1 then
		return true
	end

	if M.picker and M.picker.name then
		M.picker = nil
	end

	if M.picker and M.picker.name ~= picker.name then
		return false
	end
	M.picker = picker
	return true
end

function M.open(command, opts)
	if not M.picker then
		print("pick: picker not set")
	end

	command = command ~= "auto" and command or "files"
	opts = opts or {}

	opts = vim.deepcopy(opts)

	if type(opts.cwd) == "boolean" then
		print("pick: opts.cwd should be a string or nil")
		opts.cwd = nil
	end

	if not opts.cwd and opts.root ~= false then
		opts.cwd = Util.root({ buf = opts.buf })
	end

	command = M.picker.commands[command] or command
	-- print(command)
	M.picker.open(command, opts)
end

function M.wrap(command, opts)
	opts = opts or {}
	return function()
		M.open(command, vim.deepcopy(opts))
	end
end

function M.config_files()
	return M.wrap("files", { cwd = vim.fn.stdpath("config") })
end

return M