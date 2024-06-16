--


local language_parsers = require("settings").language_parsers
return
{
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
        "windwp/nvim-ts-autotag",
        "nvim-treesitter/nvim-treesitter-textobjects",
    },
    opts = {
        ensure_installed = language_parsers,
        auto_install = true,
        indent = { enable = true },
        -- enable autotagging (w/ nvim-ts-autotag plugin)
        autotag = {
            enable = true,
        },
    },
    config = function(_, opts)
        local treesitter = require("nvim-treesitter.configs")
        treesitter.setup(opts)
    end

}
