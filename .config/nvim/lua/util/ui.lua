local M = {}

function M.get_signs(buf, lnum)
    -- Get regular signs
    local signs = {}

    -- Get extmark signs
    local extmarks = vim.api.nvim_buf_get_extmarks(
        buf,
        -1,
        { lnum - 1, 0 },
        { lnum - 1, -1 },
        { details = true, type = "sign" }
    )
    for _, extmark in pairs(extmarks) do
        signs[#signs + 1] = {
            name = extmark[4].sign_hl_group or extmark[4].sign_name or "",
            text = extmark[4].sign_text,
            texthl = extmark[4].sign_hl_group,
            priority = extmark[4].priority,
        }
    end

    -- Sort by priority
    table.sort(signs, function(a, b)
        return (a.priority or 0) < (b.priority or 0)
    end)

    return signs
end

function M.get_mark(buf, lnum)
    local marks = vim.fn.getmarklist(buf)
    vim.list_extend(marks, vim.fn.getmarklist())
    for _, mark in ipairs(marks) do
        if mark.pos[1] == buf and mark.pos[2] == lnum and mark.mark:match("[a-zA-Z]") then
            return { text = mark.mark:sub(2), texthl = "DiagnosticHint" }
        end
    end
end

function M.icon(sign, len)
    sign = sign or {}
    len = len or 2
    local text = vim.fn.strcharpart(sign.text or "", 0, len) ---@type string
    text = text .. string.rep(" ", len - vim.fn.strchars(text))
    return sign.texthl and ("%#" .. sign.texthl .. "#" .. text .. "%*") or text
end

function M.statuscolumn()
    local win = vim.g.statusline_winid
    local buf = vim.api.nvim_win_get_buf(win)
    local is_file = vim.bo[buf].buftype == ""
    local show_signs = vim.wo[win].signcolumn ~= "no"

    local components = { "", "", "" } -- left, middle, right

    local show_open_folds = vim.g.lazyvim_statuscolumn and vim.g.lazyvim_statuscolumn.folds_open
    local use_githl = vim.g.lazyvim_statuscolumn and vim.g.lazyvim_statuscolumn.folds_githl

    if show_signs then
        local signs = M.get_signs(buf, vim.v.lnum)

        ---@type Sign?,Sign?,Sign?
        local left, right, fold, githl
        for _, s in ipairs(signs) do
            if s.name and (s.name:find("GitSign") or s.name:find("MiniDiffSign")) then
                right = s
                if use_githl then
                    githl = s["texthl"]
                end
            else
                left = s
            end
        end

        vim.api.nvim_win_call(win, function()
            if vim.fn.foldclosed(vim.v.lnum) >= 0 then
                fold = { text = vim.opt.fillchars:get().foldclose or "", texthl = githl or "Folded" }
            elseif
                show_open_folds
                -- and not LazyVim.ui.skip_foldexpr[buf]
                and tostring(vim.treesitter.foldexpr(vim.v.lnum)):sub(1, 1) == ">"
            then -- fold start
                fold = { text = vim.opt.fillchars:get().foldopen or "", texthl = githl }
            end
        end)
        -- Left: mark or non-git sign
        components[1] = M.icon(M.get_mark(buf, vim.v.lnum) or left)
        -- Right: fold icon or git sign (only if file)
        components[3] = is_file and M.icon(fold or right) or ""
    end

    components[2] = "%2r  %2l"
    return table.concat(components, "")
end

function M.fg(name)
    local color = M.color(name)
    return color and { fg = color } or nil
end

function M.color(name, bg)
    ---@type {foreground?:number}?
    ---@diagnostic disable-next-line: deprecated
    local hl = vim.api.nvim_get_hl and vim.api.nvim_get_hl(0, { name = name, link = false })
        or vim.api.nvim_get_hl_by_name(name, true)
    ---@diagnostic disable-next-line: undefined-field
    ---@type string?
    local color = nil
    if hl then
        if bg then
            color = hl.bg or hl.background
        else
            color = hl.fg or hl.foreground
        end
    end
    return color and string.format("#%06x", color) or nil
end

return M
