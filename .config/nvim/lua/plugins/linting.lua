-- Plugin `nvim-lint` highlights syntax errors, style issues, and potential bugs in real-time.

local linters = require("settings").linters

return {
    "mfussenegger/nvim-lint",
    enabled = true,
    event = {
        "BufReadPre",
        "BufNewFile",
    },
    config = function()
        local lint = require("lint")

        lint.linters_by_ft = linters

        local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

        vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave", "TextChanged" }, {
            -- group = lint_augroup,
            callback = function()
                lint.try_lint()
            end,
        })
    end,
}
