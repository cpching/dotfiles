-- colorscheme.lua
-- Load the selected colorscheme dynamically

-- Import the settings module to get the selected colorscheme
local settings = require('settings')

-- Function to load the colorscheme configuration
local function load_colorscheme(colorscheme)
  local ok, scheme_module = pcall(require, 'plugins.colorschemes.' .. colorscheme)
  if not ok then
    vim.notify("Colorscheme module 'plugins.colorscheme." .. colorscheme .. "' not found!", vim.log.levels.ERROR)
    return {}
  end
  return scheme_module
end

-- Return the colorscheme configuration for lazy.nvim
return load_colorscheme(settings.colorscheme)

