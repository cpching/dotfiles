-- Plugin `nvim-surround` enhances text manipulation by providing operators to surround text with pairs of characters (e.g., parentheses, quotes).

return
{
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
        require("nvim-surround").setup({
            -- Configuration here, or leave empty to use defaults
        })
    end
}

