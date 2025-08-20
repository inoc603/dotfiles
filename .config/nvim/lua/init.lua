vim.pack.add({
    { src = "https://github.com/folke/lazy.nvim.git" }
})

require("lazy").setup("plugins")

vim.api.nvim_set_keymap("n", "<leader>n", "gcc", {})
vim.api.nvim_set_keymap("x", "<leader>n", "gc", {})

vim.keymap.set('n', '<leader>o', function()
    local current_file = vim.fn.expand('%:p')
    local jumplist = vim.fn.getjumplist()
    local jumps = jumplist[1]
    local current_pos = jumplist[2]

    -- Look backwards through jumplist for a different file
    for i = current_pos, 1, -1 do
        local jump = jumps[i]
        if jump and jump.bufnr and jump.bufnr ~= vim.fn.bufnr('%') then
            local bufname = vim.fn.bufname(jump.bufnr)
            if bufname ~= '' and vim.fn.fnamemodify(bufname, ':p') ~= current_file then
                vim.cmd('buffer ' .. jump.bufnr)
                vim.fn.cursor(jump.lnum, jump.col + 1)
                return
            end
        end
    end

    print("No previous file in jumplist")
end, { desc = "Jump to prev file in jumplist" })
