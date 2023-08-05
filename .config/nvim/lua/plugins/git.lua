return {
    -- Show git diff
    'airblade/vim-gitgutter',
    -- Git intergration
    'tpope/vim-fugitive',
    -- Using tig in vim
    {
        'iberianpig/tig-explorer.vim',
        config = function()
            -- open tig with Project root path
            vim.keymap.set("n", "<Leader>T", ":TigOpenProjectRootDir<CR>")
        end
    },
}
