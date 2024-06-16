--

return
{
    'stevearc/aerial.nvim',
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons"
    },
    opts = {
        layout =
        {
            max_width = { 40, 0.2 },
            width = nil,
            min_width = 30,
        },
        on_attach = function(bufnr)
            -- Jump forwards/backwards with '{' and '}'
            vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
            vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
        end,
    },
    config = function(_, opts)
        local aerial = require("aerial")

        aerial.setup(opts)
        -- You probably also want to set a keymap to toggle aerial
        vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>")
    end
}
