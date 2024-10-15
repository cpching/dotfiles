-- Plugin `conform` automatically formats code and enforces style rules.

local formmaters = require("settings").formatters
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

        -- Use a list to run multiple formatters sequentially
        -- Use a sub-list to run only the first available formatter
        formatters_by_ft = formmaters,
        format_on_save = {
            -- I recommend these options. See :help conform.format for details.
            lsp_fallback = true,
            timeout_ms = 500,
        }
    }
}
