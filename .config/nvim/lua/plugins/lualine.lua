-- Plugin `lualine.nvim` provides a customizable statusline that displays key information such as mode, file status, and more.
return
{
    {
        'nvim-lualine/lualine.nvim',
        dependencies = 'nvim-tree/nvim-web-devicons',
        event = "VeryLazy",
        opts = {
            theme = 'nord',
            globalstatus = true,
            extensions = {'nvim-tree'}
        },
    }
}

