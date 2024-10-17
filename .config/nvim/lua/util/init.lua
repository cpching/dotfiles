local Util = {}
Util.lualine = require("util.lualine")
Util.ui = require("util.ui")
Util.root = require("util.root")
Util.lsp = require("util.lsp")
Util.pick = require("util.pick")

function Util.is_win()
	return vim.uv.os_uname().sysname:find("Windows") ~= nil
end

return Util
