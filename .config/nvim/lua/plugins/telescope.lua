-- TODO: adjust the `layout_config`
local picker = {
	name = "telescope",
	commands = {
		files = "find_files",
		-- TODO: file browser
		browser = "file_browser",
	},
	-- this will return a function that calls telescope.
	-- cwd will default to lazyvim.util.get_root
	-- for `files`, git_files or find_files will be chosen depending on .git
	open = function(builtin, opts)
		opts = opts or {}
		opts.follow = opts.follow ~= false
		if opts.cwd and opts.cwd ~= vim.uv.cwd() then
			local function open_cwd_dir()
				local action_state = require("telescope.actions.state")
				local line = action_state.get_current_line()
				Util.pick.open(
					builtin,
					vim.tbl_deep_extend("force", {}, opts or {}, {
						root = false,
						default_text = line,
					})
				)
			end
			---@diagnostic disable-next-line: inject-field
			opts.attach_mappings = function(_, map)
				-- opts.desc is overridden by telescope, until it's changed there is this fix
				map("i", "<a-c>", open_cwd_dir, { desc = "Open cwd Directory" })
				return true
			end
		end

		require("telescope.builtin")[builtin](opts)
		-- FIX: telescope extensions loading error `file_browser` can't be called
		-- require("telescope.extensions")[builtin](opts)
	end,
}
if not Util.pick.register(picker) then
	return {}
end

return {
	{
		"nvim-telescope/telescope.nvim",
		-- branch = "0.1.x",
		dependencies = {
			"nvim-telescope/telescope-ui-select.nvim",
			"nvim-telescope/telescope-fzf-native.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"folke/todo-comments.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		event = { "VeryLazy" },
		keys = {
			-- TODO: root
			{ "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },

			{
				"<leader>ft",
				"<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>",
				desc = "Find Buffer",
			},
			{ "<leader>fF", Util.pick("files"), desc = "Find Files (Root Dir)" },
			{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files (Current Dir)" },
			{ "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
			{ "<leader>fR", Util.pick("oldfiles", { cwd = vim.uv.cwd() }), desc = "Recent (Current Dir)" },
			{ "<leader>fg", "<cmd>Telescope git_files<cr>", desc = "Find Files (git-files)" },
			{ "<leader>fb", "<cmd>Telescope file_browser<cr>", desc = "File Browser" },
			{ "<leader>fc", Util.pick.config_files(), desc = "Config Files" },

			{ "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "Commits" },
			{ "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "Status" },

			{ '<leader>s"', "<cmd>Telescope registers<cr>", desc = "Registers" },
			{ "<leader>sa", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
			{ "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
			{ "<leader>sc", "<cmd>Telescope commands<cr>", desc = "Commands" },
			{ "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document Diagnostics" },
			{ "<leader>sD", "<cmd>Telescope diagnostics<cr>", desc = "Workspace Diagnostics" },
			{ "<leader>sS", Util.pick("live_grep"), desc = "Grep (Root Dir)" },
			{ "<leader>ss", "<cmd>Telescope live_grep<cr>", desc = "Search String (Current Dir)" },
			{ "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
			{ "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Search Highlight Groups" },
			{ "<leader>sj", "<cmd>Telescope jumplist<cr>", desc = "Jumplist" },
			{ "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
			{ "<leader>sl", "<cmd>Telescope loclist<cr>", desc = "Location List" },
			{ "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
			{ "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
			{ "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
			{ "<leader>sR", "<cmd>Telescope resume<cr>", desc = "Resume" },
			{ "<leader>sq", "<cmd>Telescope quickfix<cr>", desc = "Quickfix List" },
			-- { "<leader>sw", "<cmd>Telescope grep_string<cr>", desc = "Word" },
			{ "<leader>sw", Util.pick("grep_string", { word_match = "-w" }), desc = "Word (Root Dir)" },
			{
				"<leader>sW",
				Util.pick("grep_string", { root = false, word_match = "-w" }),
				desc = "Word (Current Dir)",
			},
			{ "<leader>sw", Util.pick("grep_string"), mode = "v", desc = "Selection (Root Dir)" },
			{ "<leader>sW", Util.pick("grep_string", { root = false }), mode = "v", desc = "Selection (Current Dir)" },
			{ "<leader>uC", Util.pick("colorscheme", { enable_preview = true }), desc = "Colorscheme with Preview" },

			{ "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
			{ "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
		},

		opts = function()
			local actions = require("telescope.actions")
			local fb_actions = require("telescope._extensions.file_browser.actions")

			local function find_command()
				if 1 == vim.fn.executable("rg") then
					return { "rg", "--files", "--color", "never", "-g", "!.git" }
				elseif 1 == vim.fn.executable("fd") then
					return { "fd", "--type", "f", "--color", "never", "-E", ".git" }
				elseif 1 == vim.fn.executable("fdfind") then
					return { "fdfind", "--type", "f", "--color", "never", "-E", ".git" }
				elseif 1 == vim.fn.executable("find") and vim.fn.has("win32") == 0 then
					return { "find", ".", "-type", "f" }
				elseif 1 == vim.fn.executable("where") then
					return { "where", "/r", ".", "*" }
				end
			end

			return {
				defaults = {
					-- path_display = { "smart" },
					mappings = {
						i = {
							["<M-j>"] = actions.move_selection_next, -- move to next result
							["<M-k>"] = actions.move_selection_previous, -- move to prev result
							["?"] = "which_key",
						},
						n = {
							["q"] = actions.close,
						},
					},
					prompt_prefix = " ",
					selection_caret = " ", --  ⌕
				},
				pickers = {
					find_files = {
						-- theme = "dropdown",
						find_command = find_command,
						hidden = true,
					},
				},
				extensions = {
					--[[ ["ui-select"] = {
						require("telescope.themes").get_dropdown({
							-- even more opts
						}),
					}, ]]
					fzf = {
						fuzzy = true, -- false will only do exact matching
						override_generic_sorter = true, -- override the generic sorter
						override_file_sorter = true, -- override the file sorter
						case_mode = "smart_case", -- or "ignore_case" or "respect_case"
						-- the default case_mode is "smart_case"
					},
					-- TODO: Result Title
					file_browser = {
						sorting_strategy = "ascending",
						layout_config = {
							horizontal = {
								prompt_position = "top",
								preview_width = 0.3,
								height = 0.75,
							},
						},
						mappings = { ["n"] = { ["u"] = fb_actions.goto_parent_dir } },
						initial_mode = "normal",
						-- results_title = vim.uv.cwd(),
					},
				},
			}
		end,
		config = function(_, opts)
			local telescope = require("telescope")
			telescope.setup(opts)
			telescope.load_extension("fzf")
			telescope.load_extension("ui-select")
			telescope.load_extension("file_browser")
		end,
	},
	{
		"nvim-telescope/telescope-file-browser.nvim",
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
		enabled = true,
	},
	{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	-- Flash Telescope config
	{
		"nvim-telescope/telescope.nvim",
		optional = true,
		opts = function(_, opts)
			local function flash(prompt_bufnr)
				require("flash").jump({
					pattern = "^",
					label = { after = { 0, 0 } },
					search = {
						mode = "search",
						exclude = {
							function(win)
								return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "TelescopeResults"
							end,
						},
					},
					action = function(match)
						local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
						picker:set_selection(match.pos[1] - 1)
					end,
				})
			end
			opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
				mappings = { n = { s = flash }, i = { ["<c-s>"] = flash } },
			})
		end,
	},
}
