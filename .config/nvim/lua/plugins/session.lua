return {
	{
		"folke/persistence.nvim",
		event = "BufReadPre",
		opts = {
			options = { "buffers", "curdir", "tabpages", "winsize" }, -- sessionoptions used for saving
			save_empty = false,
		},
        -- stylua: ignore
        keys = {
            { "<leader>qr", function() require("persistence").load() end, desc = "Restore Session" },
            { "<leader>qs", function() require("persistence").select() end,desc = "Select Session" },
            { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
            { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
        },
	},
	--[[ {
		"rmagatti/auto-session",
		lazy = false,
		opts = {

			log_level = "info",
			auto_session_last_session = false,
			-- auto_session_root_dir = "~/test/", -- change this!
			auto_session = false,
			-- auto_save_enabled = false,
			auto_restore = false,
			auto_session_suppress_dirs = nil,
			-- pre_save_cmds = { "tabdo NvimTreeClose" },
			-- post_restore_cmds = { "tabdo NvimTreeRefresh" },
		},
		config = function(_, opts)
			vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
			require("auto-session").setup(opts)
		end,
	}, ]]
}
