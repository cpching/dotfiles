return
{
    "folke/which-key.nvim",
    lazy = true,
    event = "VeryLazy",
    init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 300
    end,
    opts = {
        icons = {
            breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
            separator = "➜ ", -- symbol used between a key and it's label
            group = "+", -- symbol prepended to a group
        },
        win = {
            no_overlap = true,
            border = "none",    -- none, single, double, shadow, rounded
            padding = { 1, 1 }, -- extra window padding [top, right, bottom, left]
            title = true,
            title_pos = "center",
        },
        layout = {
            height = { min = 1, max = 25 }, -- min and max height of the columns
            width = { min = 20, max = 50 }, -- min and max width of the columns
            spacing = 3,                    -- spacing between columns
            align = "left",                 -- align columns left, center or right
        },
    },
    keys = {
        {
            "<leader>?",
            function()
                require("which-key").show({ global = false })
            end,
            desc = "Buffer Local Keymaps (which-key)",
        },
    }
}
