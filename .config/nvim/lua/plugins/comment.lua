-- Plugin `Comment` improves the commenting workflow in Neovim by providing toggling.

return
{
    "numToStr/Comment.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "JoosepAlviste/nvim-ts-context-commentstring",
    },
    opts = {
        sticky = false,
        toggler = {
            line = '<C-_>' -- Use Ctrl+_ (Ctrl+/) as the shortcut to toggle comments on the current line.
        },
    },
    config = function(_, opts)
        -- import comment plugin safely
        local comment = require("Comment")

        -- for commenting tsx, jsx, svelte, html files
        local ts_context_commentstring = require("ts_context_commentstring.integrations.comment_nvim")
        opts["pre_hook"] = ts_context_commentstring.create_pre_hook()

        -- enable comment
        comment.setup(opts)
    end,
}

