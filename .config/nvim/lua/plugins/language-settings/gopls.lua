return {
    settings = {
        gopls = {
            completeUnimported = true,
            analyses = {
                unusedparams = true,
                shadow = true,
            },
            staticcheck = true,
            gofumpt = true,
            usePlaceholders = true,
            hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
            },
            diagnosticsDelay = "0ms", -- Set a specific delay for diagnostics
            matcher = "Fuzzy",        -- This can sometimes help with performance
            symbolMatcher = "fuzzy",
        },
    },
}
