local language_servers = {
    "lua_ls",
    "clangd",  -- C/C++
    "html",
    "tsserver",
    "golangci_lint_ls",
    "gopls"
}

return
{
    {
        "williamboman/mason.nvim",
        enabled = true,
        opts = {
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
                border = "rounded",
            },
        }
    },
    {
        'williamboman/mason-lspconfig.nvim',
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = language_servers,
                automatic_installation = true,
            })
        end,
        dependencies = {'williamboman/mason.nvim'}
    },
    {
        'neovim/nvim-lspconfig',
        enabled = true,
        dependencies = {"williamboman/mason-lspconfig.nvim", "williamboman/mason.nvim", "hrsh7th/cmp-nvim-lsp" },
        config = function ()
            local on_attach = function(client, bufnr)
                if client.name == "tsserver" then
                    client.server_capabilities.documentFormattingProvider = false
                end
                local opts = { noremap = true, silent = true }
                local buf_keymap = vim.api.nvim_buf_set_keymap
                buf_keymap(bufnr, "n", "<leader>gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
                buf_keymap(bufnr, "n", "<leader>gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
                buf_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
                buf_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
                buf_keymap(bufnr, "n", "<C-s>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
                buf_keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
                buf_keymap(bufnr, "n", "gl", '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
                buf_keymap(bufnr, "n", "[d", '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>', opts)
                buf_keymap(bufnr, "n", "]d", '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>', opts)
                buf_keymap(bufnr, "n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
                vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]
                --  lsp_keymaps(bufnr)
                -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
                -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
                -- lsp_highlight_document(client)
            end

            -- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
            local capabilities
            local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
            if status_ok then
                capabilities = cmp_nvim_lsp.default_capabilities()
            end

            local opts = {
                on_attach = on_attach,
                capabilities = capabilities,
            }

            local lspconfig = require('lspconfig')

            local signs = {
                { name = "DiagnosticSignError", text = "" },
                { name = "DiagnosticSignWarn", text = "" },
                { name = "DiagnosticSignHint", text = "" },
                { name = "DiagnosticSignInfo", text = "" },
            }
            for _, sign in ipairs(signs) do
                vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
            end
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

            vim.diagnostic.config(config)
            vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
                border = "rounded",
            })

            vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
                border = "rounded",
            })


            for _, language_server in pairs(language_servers) do
                language_server = vim.split(language_server, "@")[1]
                local require_ok, conf_opts = pcall(require, "plugins.language-settings." .. language_server)
                if require_ok  then
                    conf_opts = vim.tbl_deep_extend("keep", conf_opts, opts)
                    lspconfig[language_server].setup(conf_opts)
                else
                    lspconfig[language_server].setup(opts)
                end
            end
        end
    }
}

