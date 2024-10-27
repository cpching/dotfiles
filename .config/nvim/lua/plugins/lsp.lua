-- Plugin `mason` provides an easy way to install and mange LSP servers, DAP servers, linters, and formatters.
-- Plugin `mason-lspconfig` simplifies the integration of lspconfig with the `mason` plugin.
-- Plugin `nvim-lspconfig` integrates various LSP servers.

local language_servers = Config.settings.language_servers

return {
	{
		"williamboman/mason-lspconfig.nvim",
		-- event = "VeryLazy",
		opts = {
			ensure_installed = language_servers,
			automatic_installation = true,
		},
	},
	{
		"neovim/nvim-lspconfig",
		enabled = true,
        -- stylua: ignore
		keys = {
			{ "gD", vim.lsp.buf.declaration, noremap = true, silent = true, desc = "Go to Declaration", },
			{ "gd", vim.lsp.buf.definition, noremap = true, silent = true, desc = "Go to Definition", },
			{ "K", vim.lsp.buf.hover, noremap = true, silent = true, desc = "Hover", },
			{ "gi", vim.lsp.buf.implementation, noremap = true, silent = true, desc = "Go to Implementation", },
			{ "gK", vim.lsp.buf.signature_help, noremap = true, silent = true, desc = "Signature Help", },
			{ "<C-S>", vim.lsp.buf.signature_help, mode = "i", noremap = true, silent = true, desc = "Signature Help", },
			{ "gr", vim.lsp.buf.references, noremap = true, silent = true, desc = "Go to References", },
			{ "gl", vim.diagnostic.open_float, noremap = true, silent = true, desc = "Open Diagnostic Float", },
			{ "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "v" }, },
			{ "<leader>cl", vim.lsp.codelens.run, desc = "Run Codelens", mode = { "n", "v" }, },
			{ "<leader>cL", vim.lsp.codelens.refresh, desc = "Refresh & Display Codelens", mode = { "n" }, },
			{ "<leader>cr", vim.lsp.buf.rename, noremap = true, silent = true, desc = "Rename Symbol", },
			{ "[e", vim.diagnostic.goto_prev, noremap = true, silent = true, desc = "Prev Error", },
			{ "]e", vim.diagnostic.goto_next, noremap = true, silent = true, desc = "Next Error", },
			{ "<leader>e", vim.diagnostic.setloclist, noremap = true, silent = true, desc = "Set Location List", },
		},
		dependencies = { "williamboman/mason-lspconfig.nvim", "williamboman/mason.nvim", "hrsh7th/cmp-nvim-lsp" },
		opts = function()
			local ret = {
				diagnostics = {
					virtual_text = {
						spacing = 4,
						source = "if_many",
						prefix = "",
						-- 
					},
					signs = {
						text = {
							[vim.diagnostic.severity.ERROR] = "",
							[vim.diagnostic.severity.WARN] = "",
							[vim.diagnostic.severity.HINT] = "",
							[vim.diagnostic.severity.INFO] = "",
						},
						-- active = signs,
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
				},
			}
			return ret
		end,
		config = function(_, opts)
			-- The `nvim-cmp` almost supports LSP's capabilities so You should advertise it to LSP servers..
			local capabilities
			local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
			if status_ok then
				capabilities = cmp_nvim_lsp.default_capabilities()
			end

			-- Define diagnostic configuration for virtual text, signs, and float windows.

			-- Configure diagnostics with defined settings.
			vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

			-- Customize hover and signature help handlers for LSP.
			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
				border = "rounded",
			})

			vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
				border = "rounded",
			})

			local server_opts = {
				-- on_attach = on_attach,
				capabilities = capabilities,
			}

			-- Setup LSP servers based on predefined configurations.
			for _, language_server in pairs(language_servers) do
				language_server = vim.split(language_server, "@")[1]
				local lspconfig = require("lspconfig")
				local require_ok, conf_opts = pcall(require, "plugins.language-settings." .. language_server)
				if require_ok then
					conf_opts = vim.tbl_deep_extend("keep", conf_opts, server_opts)
					lspconfig[language_server].setup(conf_opts)
				else
					lspconfig[language_server].setup(server_opts)
				end
			end
		end,
	},
}
