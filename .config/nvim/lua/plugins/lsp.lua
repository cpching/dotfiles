-- Plugin `mason` provides an easy way to install and mange LSP servers, DAP servers, linters, and formatters.
-- Plugin `mason-lspconfig` simplifies the integration of lspconfig with the `mason` plugin.
-- Plugin `nvim-lspconfig` integrates various LSP servers.

local language_servers = require("settings").language_servers

return
{
    {
        'williamboman/mason-lspconfig.nvim',
        opts = {
            ensure_installed = language_servers,
            automatic_installation = true
        }
    },
    {
        'neovim/nvim-lspconfig',
        enabled = true,
        keys = {
            { "<leader>gD", "<cmd>lua vim.lsp.buf.declaration()<CR>",                        noremap = true, silent = true, desc = "Go to declaration" },
            { "<leader>gd", "<cmd>lua vim.lsp.buf.definition()<CR>",                         noremap = true, silent = true, desc = "Go to declaration" },
            { "K",          "<cmd>lua vim.lsp.buf.hover()<CR>",                              noremap = true, silent = true },
            { "gi",         "<cmd>lua vim.lsp.buf.implementation()<CR>",                     noremap = true, silent = true, desc = "Go to implementation" },
            { "<C-s>",      "<cmd>lua vim.lsp.buf.signature_help()<CR>",                     noremap = true, silent = true },
            { "gr",         "<cmd>lua vim.lsp.buf.references()<CR>",                         noremap = true, silent = true, desc = "Go to references" },
            { "gl",         '<cmd>lua vim.diagnostic.open_float()<CR>',                      noremap = true, silent = true, desc = "Open diagnostic float" },
            { "[e",         '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>', noremap = true, silent = true, desc = "Prev error" },
            { "]e",         '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>', noremap = true, silent = true, desc = "Next error" },
            { "<leader>q",  "<cmd>lua vim.diagnostic.setloclist()<CR>",                      noremap = true, silent = true, desc = "Set Location List" },
            { "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>",                             noremap = true, silent = true, desc = "Rename symbol" },
        },
        dependencies = { "williamboman/mason-lspconfig.nvim", "williamboman/mason.nvim", "hrsh7th/cmp-nvim-lsp" },
        config = function()
            -- The `nvim-cmp` almost supports LSP's capabilities so You should advertise it to LSP servers..
            local capabilities
            local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
            if status_ok then
                capabilities = cmp_nvim_lsp.default_capabilities()
            end

            local lspconfig = require('lspconfig')

            -- Define diagnostic signs for error, warning, hint, and info.
            local signs = {
                { name = "DiagnosticSignError", text = "" },
                { name = "DiagnosticSignWarn", text = "" },
                { name = "DiagnosticSignHint", text = "" },
                { name = "DiagnosticSignInfo", text = "" },
            }
            for _, sign in ipairs(signs) do
                vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
            end

            -- Define diagnostic configuration for virtual text, signs, and float windows.
            local config = {
                virtual_text = true,
                signs = {
                    active = signs,
                },
                update_in_insert = true,
                underline = true,
                severity_sort = true,
                float = {
                    focusable = true,
                    style = "minimal",
                    border = "rounded",

                    header = "",
                    prefix = "",
                },
            }

            -- Configure diagnostics with defined settings.
            vim.diagnostic.config(config)

            -- Customize hover and signature help handlers for LSP.
            vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
                border = "rounded",
            })

            vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
                border = "rounded",
            })

            local opts = {
                -- on_attach = on_attach,
                capabilities = capabilities,
            }

            -- Setup LSP servers based on predefined configurations.
            for _, language_server in pairs(language_servers) do
                language_server = vim.split(language_server, "@")[1]
                local require_ok, conf_opts = pcall(require, "plugins.language-settings." .. language_server)
                if require_ok then
                    conf_opts = vim.tbl_deep_extend("keep", conf_opts, opts)
                    lspconfig[language_server].setup(conf_opts)
                else
                    lspconfig[language_server].setup(opts)
                end
            end
        end
    }
}
