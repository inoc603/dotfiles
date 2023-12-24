if (vim.fn.findfile("~/.local/share/venv/neovim/bin/python3") ~= '')
then
    vim.g.python3_host_prog = "~/.local/share/venv/neovim/bin/python"
    vim.g.python_host_prog = "~/.local/share/venv/neovim/bin/python"
    vim.g.loaded_ruby_provider = 0
    vim.g.loaded_node_provider = 0
    vim.g.loaded_perl_provider = 0
end

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

require("lazy").setup("plugins")

vim.api.nvim_create_autocmd("VimEnter", {
    desc = "Auto select virtualenv Nvim open",
    pattern = "*",
    callback = function()
        local venv = vim.fn.findfile("pyproject.toml", vim.fn.getcwd() .. ";")
        if venv ~= "" then
            require("venv-selector").retrieve_from_cache()
        end
    end,
    once = true,
})
