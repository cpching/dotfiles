local opt = vim.opt
opt.number = true
opt.relativenumber = true
opt.smartindent = true
opt.smartcase = true
opt.linebreak = true
opt.termguicolors = true
opt.ruler = true
opt.cursorline = true
opt.ignorecase = true
opt.smartcase = true
opt.encoding = "utf-8"
opt.fileencodings = "utf-8"
opt.smarttab = true
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.hidden = true
opt.mouse = "i"
opt.statuscolumn = [[%!v:lua.require'util.ui'.statuscolumn()]]
opt.signcolumn = "yes"
opt.linebreak = true
opt.undofile = true
opt.showmode = false
opt.laststatus = 3 -- global statusline
