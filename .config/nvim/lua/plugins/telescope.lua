return
{
    "nvim-telescope/telescope.nvim",
    -- branch = "0.1.x",
    dependencies = {
        "nvim-telescope/telescope-ui-select.nvim",
        "nvim-telescope/telescope-fzf-native.nvim",
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "folke/todo-comments.nvim",
        "nvim-treesitter/nvim-treesitter"
    },
    config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")

        telescope.setup({
            defaults = {
                path_display = { "smart" },
                mappings = {
                    i = {
                        ["<M-k>"] = actions.move_selection_previous, -- move to prev result
                        ["<M-j>"] = actions.move_selection_next,     -- move to next result
                        ["?"] = "which_key"
                    },
                },
                prompt_prefix = " ",
                selection_caret = " ", --  ⌕
            },
            pickers = {
                find_files = {
                    theme = "dropdown",
                }
            },
            extensions = {
                ["ui-select"] = {
                    require("telescope.themes").get_dropdown {
                        -- even more opts
                    }
                }
            }
        })
        telescope.load_extension("fzf")
        telescope.load_extension("ui-select")

        -- set keymaps
        local keymap = vim.keymap -- for conciseness

        keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
        keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
        keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
        keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
        keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
    end,
}
