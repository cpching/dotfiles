return
{
    'akinsho/bufferline.nvim',
    dependencies = 'nvim-tree/nvim-web-devicons',
    event = "VeryLazy",
    keys = {
    },
    opts = {
        options = {
            always_show_bufferline = true,
            offsets = { { filetype = "NvimTree", text = "", padding = 1 } },
            separator_style = "slant",
        },
    },
}

