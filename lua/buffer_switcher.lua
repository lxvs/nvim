local function bn_non_t(reverse)
    reverse = reverse or false

    -- Build list of listed, non-terminal buffers
    local otherbuflist = {}
    for buf = 1, vim.fn.bufnr('$') do
        if vim.fn.buflisted(buf) == 1 and vim.bo[buf].buftype ~= "terminal" then
            table.insert(otherbuflist, buf)
        end
    end

    local otherbuflen = #otherbuflist
    local curbuf = vim.fn.bufnr("%")

    -- If no alternative buffer, or only one and current isn't terminal, do nothing
    if otherbuflen == 0 or (otherbuflen < 2 and vim.bo.buftype ~= "terminal") then
        return
    end

    -- Find current buffer in the list
    local curidx = -1
    for i, b in ipairs(otherbuflist) do
        if b == curbuf then
            curidx = i
            break
        end
    end

    if curidx == -1 then
        -- Current buffer is not in otherbuflist (e.g., terminal)
        local cmd = reverse and "bprevious" or "bnext"
        vim.cmd(cmd)

        -- Keep skipping terminals
        while vim.bo.buftype == "terminal" and vim.fn.bufnr("%") ~= curbuf do
            vim.cmd(cmd)
        end
    else
        -- Current buffer is in non-terminal list → jump within list
        local newidx
        if reverse then
            newidx = (curidx - 2) % otherbuflen + 1      -- adjust for Lua 1-based
        else
            newidx = (curidx % otherbuflen) + 1          -- forward
        end

        vim.cmd("buffer " .. otherbuflist[newidx])
    end
end

vim.keymap.set({'n', 'v'}, '<Tab>', function() bn_non_t() end, {silent = true})
vim.keymap.set({'n', 'v'}, '<S-Tab>', function() bn_non_t(true) end, {silent = true})
