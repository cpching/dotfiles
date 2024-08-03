-- Plugin `LuaSnip` provides a powerful snippet engine for Neovim, designed to enhance code productivity by providing snippet expansions.
-- Plugin `friendly-snippets` provides a collection of pre-defined snippets for various programming languages and frameworks.

return
{
    {
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!).
        build = "make install_jsregexp",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
        end,
    },
}
