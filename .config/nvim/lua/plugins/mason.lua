return {
	"williamboman/mason.nvim",
	event = "VeryLazy",
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
	},
}
