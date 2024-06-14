# Neovim   
# Introduction   
- This note is written to help you configure Neovim using Lua. It includes the following sections:   
- **Installation**: Instructions for installing Neovim   
- **Using Lua**: How to load Lua modules in Neovim   
- **Key Mappings**: Mapping Vim commands or Lua functions to key sequences   
- **Options**: Setting useful options clearly via Lua   
- **Plugin** **Manager** **-** **Lazy**: Installing and configuring Lazy to manage plugins   
- **Plugins**: Useful plugins and their configurations   

# Installation   
``` lua
# Homebrew on macOS or Linux
brew install neovim
```

# Using Lua   
## Directory Structure (Example)   
``` lua
~/.config/nvim
|-- init.lua # [or init.vim (https://neovim.io/doc/user/lua-guide.html#lua-guide-config)]
    |-- lua/
|-- module_a.lua # (e.g. keymaps.lua or options.lua) 
    |-- plugin-manager.lua
    |-- plugins/
    |-- init.lua 
    |-- plugin_a.lua
    |-- plugin_b.lua
```

## [Lua Modules](https://neovim.io/doc/user/lua-guide.html#lua-guide-modules)   
    - Lua modules are found inside a `lua/` folder in your `'runtimepath'` (for most users, this will mean `~/.config/nvim/lua` on \*NIX systems and `~/AppData/Local/nvim/lua` on Windows). You can `require()` files in this folder as Lua modules.   
    - Place `Lua` files in the `lua` directory in `‘runtimepath’` and load them with require   
- Load `module\_a.luad` (inside the `lua/` folder)   
    ``` lua
    require("module_a")
    ```
- Load `plugins/plugin\_a.lua` (inside the `lua/` folder)   
    ``` lua  
    require('plugins/plugin_a')
    -- or
    require('plugins.plugin_a')
    ```
- Load `plugins/init.lua` (inside the `lua/` folder)   
    ``` lua
    require('plugins')
    ```


# Key Mappings   
    - You can customize Neovim's key bindings by mapping either Vim commands or Lua functions to key sequences   
    - You can create a new file named `keymaps.lua` to hold the mapping code.   
    - Place the file in the `lua` directory   
    - Load the file in `init.lua`    

## keymap function in Lua   
    - Neovim's API `[vim.api.nvim\_set\_keymap](https://neovim.io/doc/user/api.html#nvim_set_keymap())` sets a global mapping for the given mode   
    - Function interface: `nvim\_set\_keymap( {mode}, {lhs}, {rhs}, {opts})`    
    - mode: Mode short-name (e.g. n, i, v, …) 要綁定的 mode   
    - lhs: Left-hand-side of the mapping. 要把什麼 key 綁定功能（之後使用的快捷鍵）   
    - rhs: Right-hand-side f the mapping. 要綁定什麼功能   
    - opts: Optional parameters map. 綁定設定，通常會設定 `noremap` 和 `silent`（我沒找到完整的文件 list）   
    - `noremap` 為 true 是指這個 mapping 是 **non-recursive** 的，它會直接 map 到把 `rhs` 當作 literal string of commands 執行，不會使 `rhs` 其它 mapping 後的結果   
    - `silent` 為 true 就是不會在 command line 顯示你使用的 `rhs` ，亦即能在使用快捷鍵時不受干擾   

### Code in `keymaps.lua`    
    - Assign a variable `keymap` to hold a reference to the function   
    `local keymap = vim.api.nvims\_set\_keymap`   
    - Assign a variable `opts`  to hold opts arguments   
    `local opts = { noremap = true, silent = true }`   
    - Call `keymap` function   
    `keymap( {mode}, {lhs}, {rhs}, opts)`    
    - example: `keymap("n", "", ":update", opts) -- use Control+L to save file in Normal mode`   

## Some Recommended Mappings   
### Move text up and down   
    ``` lua
    keymap("n", "<M-j>", ":m .+1<CR>==", opts) -- Move text down
    keymap("n", "<M-k>", ":m .-2<CR>==", opts) -- Move text up

    ```
### Return to NORMAL Mode Quickly   
    - 我無法割捨的 keymap   

    ``` lua
    keymap("i", "jj", "<ESC>", opts)
    ```
### Close Buffer   
    - 前言：無法滑順地將 buffer 關閉是困擾我許久的問題，幸好最後解決的   
    - 滑順地將 buffer 關閉：利用快捷鍵將 buffer 關閉，並在剩下一個 buffer 時關掉整個 window   
    - 用 `:bd` 關到最後一個的時候會長出 [No name] buffer   

    ``` lua
    -- Function to close buffer or window
function Close_buffer_or_window()
    vim.api.nvim_command('bn!')
    local success = pcall( vim.api.nvim_command, 'bd#')
    if not success then
    vim.api.nvim_command('q')
    end
    end

    -- Map a key to call the function to close buffer or window
    vim.api.nvim_set_keymap("n", "<C-\\>", "<CMD>lua Close_buffer_or_window()<CR>", { noremap = true, silent = true })
    ```
    - 利用檢查是否能跳到下一個 buffer 判斷要關閉 buffer 還是關閉整個 window   

# Options   
    - You can customize various options and settings for Neovim.   
    - You can create an `options.lua` file in your Neovim `lua` directory   
    - Place the file in the `lua` directory   
    - Load the file in `init.lua`    

### Convenient way   
    - A special interface `vim.opt` use table indexing to set options   
    - example: `vim.opt[key] = value`    

### Code in `options.lua`    
    - Assign a variable `options`  to hold key-value pairs representing the options   
    `local options = { ... }`   
    - Iterate the `options` table to set options   
    ``` lua
    for key, value in pairs(options) do
    vim.opt[key] = value
    end

    ```


# Plugin Manager - Lazy   
## Directory Structure (Mine)   
    ``` lua
    ~/.config/nvim
    |-- init.lua
    |-- lua/
    |-- keymaps.lua
    |-- options.lua
    |-- plugin-manager.lua
    |-- plugins/
    |-- plugin_a.lua
    |-- plugin_b.lua
    ```
## Installation   
    - Add the following Lua code to bootstrap **lazy.nvim**   
    ``` lua
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
            "git",
            "clone",
            "--filter=blob:none",
            "https://github.com/folke/lazy.nvim.git",
            "--branch=stable", -- latest stable release
            lazypath,
            })
end
vim.opt.rtp:prepend(lazypath)

-- the `lua` files under `plugins` directory will be loaded
require("lazy").setup("plugins")

```
- I add the code in the file `lua/plugin-manager.lua` and load them by `require("plugin-manager.lua")` in `~/.config/nvim/init.lua`   

## Installation of Plugins   
- Add different configuration files (\*.lua) to `lua/plugins/`    
- The shortest spec for installing a plugin   
``` lua
return
{
    {
        '<plugin-short-url>'
    }
}
```

# Useful Tips   
- 如果覺得什麼事情很冗就去看 vi 能不能解決   
- [Text object](https://amikai.github.io/2020/09/22/vim-text-object/)   
- `V` （大寫）可以進入 VISUAL LINE mode   
- `Control+V` 可以進入 VISUAL BLOCK mode   
- 在 VISUAL BLOCK mode 下   
- **選擇多行後可以利用`I`（大寫） 一次插入相同內容到多行中**（也可以利用其它字元進行其它操作）   
- 在 VISUAL \* mode 下   
- ** `"\*y` 可以複製目前所選的東西進 clipboard**   
- 在 NORMAL mode 下   
- `yi`/`di`/`ci` + pair (e.g. `()`, `{}`, `""`)    
- 任一端可以將 pair 內的文字複製/刪除/刪除並進入 INSERT mode   
- `ya`/`da`/`ca` + pair (e.g. `()`, `{}`, `""`)    
- 任一端可以將 pair 內的文字和 pair 本身複製/刪除/刪除並進入 INSERT mode   
- `J`（大寫）   
- 把目前這行尾巴 `\n` 變成空格   
- `S`（大寫）或 `cc`   
- 會把目前這行清空進入 INSERT mode 並在合適的 indentation level   
- 有時候在 NORMAL mode 按 `o` 後直接離開 INSERT mode 會失去indentation level，`S`（大寫）或 `cc`可以在該 indentation level 下編輯   
- 大括號 `{` 和 `}`    
- 跳到下一個空行   
- 在 pair (e.g. (), {}, "") 的一端按下 `%`    
- 跳到另一端   
- `zz`    
- 將 cursor line 所在的這行在畫面中垂直置中   
- `>>`/`<<`    
- 調整 indent    
- 在 INSERT mode 下   
- Control+o    
- 暫時進入 NORMAL mode   
- 搜尋時加入 `\c` 字元可以忽略後面字串的大小寫   

