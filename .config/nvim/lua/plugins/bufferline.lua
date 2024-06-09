return
{
    {
        'akinsho/bufferline.nvim',
        dependencies = 'nvim-tree/nvim-web-devicons',
        event = "VeryLazy",
        keys = {
            -- {"<leader>p", "<CMD>BufferLineTogglePin<CR>", desc = "Toggle pin"},
        },
        opts = {
            options = {
                always_show_bufferline = true,
                offsets = { { filetype = "NvimTree", text = "", padding = 1 } },
                separator_style = "slant",
            },
            highlights = highlights,
        },
    }
}
