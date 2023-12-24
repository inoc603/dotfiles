return {
    { 'elzr/vim-json',              ft = 'json' },

    {
        'plasticboy/vim-markdown',
        dependencies = { 'godlygeek/tabular' },
        ft = 'markdown',
        init = function()
            vim.g.vim_markdown_folding_disabled = 1
        end,
    },

    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = "cd app && yarn install",
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" },
    },

    { 'rust-lang/rust.vim',         ft = 'rust' },

    { 'cespare/vim-toml',           ft = 'toml' },

    { 'solarnz/thrift.vim',         ft = 'thrift' },

    { 'jparise/vim-graphql',        ft = 'graphql' },

    { 'andys8/vim-elm-syntax',      ft = "elm" },

    -- JavaScript
    { 'posva/vim-vue',              ft = 'vue' },
    { 'digitaltoad/vim-pug',        ft = 'pug' },
    { 'leafgarland/typescript-vim', ft = "typescript" },
    { 'ianks/vim-tsx',              ft = "typescript" },

    { 'towolf/vim-helm' }
}
