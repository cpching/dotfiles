-- Plugin `nvim-colorizer` highlights colors

return
{
    "norcalli/nvim-colorizer.lua",
    opts =
    {
        'css',
        'javascript',
        html = {
            mode = 'foreground',
        },
        css = { rgb_fn = true, }
    },
    config = function(_, opts)
        local colorizer = require("colorizer")
        colorizer.setup(opts)
    end
}
