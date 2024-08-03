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
    }
}
