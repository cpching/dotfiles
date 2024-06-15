-- Plugin `nvim-autopairs` automatically inserts and manages pairs of characters, streamlining the coding process.

return {
    "windwp/nvim-autopairs",
    event = { "InsertEnter" },
    dependencies = {
        "hrsh7th/nvim-cmp",
    },
    opts = {},
}
