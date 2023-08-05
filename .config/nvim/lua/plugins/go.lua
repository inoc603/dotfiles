return {
    {
        'fatih/vim-go',
        ft = { 'go', 'gomod' },
        init = function()
            vim.g.go_highlight_build_constraints = 1
            vim.g.go_highlight_generate_tags     = 1
            vim.g.go_highlight_functions         = 1
            vim.g.go_highlight_function_calls    = 1
            vim.g.go_highlight_methods           = 1
            vim.g.go_def_mapping_enabled         = 0
            vim.g.go_fmt_autosave                = 0
            vim.g.go_fmt_command                 = 'goimports'
            vim.g.go_imports_autosave            = 1
            vim.g.go_imports_mode                = 'gopls'
            vim.g.go_echo_command_info           = 0
            vim.g.go_bin_path                    = vim.fn.expand("$HOME/bin")

            vim.keymap.set("n", "<leader>i", function()
                vim.cmd('GoFmt')
            end)

            vim.cmd [[au BufRead,BufNewFile *.go.tpl set filetype=gotexttmpl]]
        end,

        config = function()
            vim.cmd [[
                  " make package and import red as other keywords.
                  highlight! link goPackage TSKeyword
                  highlight! link goImport TSKeyword
                  " make nil and strings purple as other literal values.
                  highlight! link goPredefinedIdentifiers Purple
                  highlight! link goString Purple
                  highlight! link goRawString Purple
            ]]
        end
    },

    -- TODO: move elsewhere
    {
        'nvim-lua/plenary.nvim',
        config = function()
            local p = require('plenary.profile')
            vim.keymap.set("n", "<F3>", function()
                p.start("profile.log", { flame = true })
            end)
            vim.keymap.set("n", "<F4>", function()
                p.stop()
            end)
        end
    },

    -- visual code coverage
    {
        'andythigpen/nvim-coverage',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'sainnhe/gruvbox-material',
        },
        config = function()
            require("coverage").setup()

            vim.api.nvim_set_keymap('n', '<leader>c', ':Coverage<CR>', { noremap = true })
        end
    }
}
