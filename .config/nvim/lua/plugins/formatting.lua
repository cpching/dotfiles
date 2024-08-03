-- Plugin `conform` automatically formats code and enforces style rules.

return
{
    'stevearc/conform.nvim',
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        default_format_opts = {
            timeout_ms = 3000,
            async = false,           -- not recommended to change
            quiet = false,           -- not recommended to change
            lsp_format = "fallback", -- not recommended to change
        },
        formatters_by_ft = {
            -- Use a list to run multiple formatters sequentially
            -- Use a sub-list to run only the first available formatter

            lua = { "stylua" },
            python = { "isort", "black" },
            javascript = { "prettier" },
            html = { "prettier" },
            typescript = { "prettier" },
            go = { "gofmt" },
            markdownlint = { "markdownlint" },
        },
        format_on_save = {
            -- I recommend these options. See :help conform.format for details.
            lsp_fallback = true,
            timeout_ms = 500,
        }
    }
}
