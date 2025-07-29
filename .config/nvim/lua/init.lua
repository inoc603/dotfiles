vim.pack.add({
    { src = "https://github.com/folke/lazy.nvim.git" }
})

require("lazy").setup("plugins")

vim.api.nvim_set_keymap("n", "<leader>n", "gcc", {})
vim.api.nvim_set_keymap("x", "<leader>n", "gc", {})
