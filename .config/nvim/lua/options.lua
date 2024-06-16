local options =
{
	number = true,
    relativenumber = true,
	smartindent = true,
	smartcase = true,
	termguicolors = true,
	ruler = true,
	cursorline = true,
	encoding = "UTF-8",
	fileencodings = "utf-8",
	smarttab = true,
	expandtab = true,
	shiftwidth = 4,
	tabstop = 4,
	hidden = false,
	mouse="i",
    statuscolumn = "%s%2r  %2l ", -- ▎
    signcolumn = "yes"
}

for key, value in pairs(options) do
	vim.opt[key] = value
end
