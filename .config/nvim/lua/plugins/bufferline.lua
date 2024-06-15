 --[[ Plugin `bufferline` provides a customizable and visually appealing buffer line at the top of Neovim.
      It displays all open buffers (files) in a tab-like interface, making it easier to switch between them. ]]

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

