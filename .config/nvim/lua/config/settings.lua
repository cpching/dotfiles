return {
    colorscheme = "tokyonight", --[[
                                Colorschemes:
                                - nord
                                - kanagawa
                                - tokyonight
                                - gruvbox
                            ]]
    language_servers = {
        "lua_ls",
        "clangd",
        "html",
        "cssls",
        "ts_ls",
        "gopls",
        "emmet_ls",
        "eslint"
    },
    language_parsers = {
        "bash",
        "c",
        "diff",
        "html",
        "go",
        "javascript",
        "jsdoc",
        "json",
        "jsonc",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "printf",
        "python",
        "query",
        "regex",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
    },
    linters = {
        html = { "htmlhint" },
        javascript = { "eslint" },
        python = { "pylint" },
        go = { "golangcilint" },
    },
    formatters = {
        lua = { "stylua" },
        python = { "isort", "black" },
        javascript = { "prettier" },
        html = { "prettier" },
        typescript = { "prettier" },
        go = { "gofmt" },
        markdownlint = { "markdownlint" },
        cpp = { "ast-grep" },
    }
}
