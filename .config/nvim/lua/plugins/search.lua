return {
    {
        'nvim-telescope/telescope.nvim',
        -- tag = '0.1.1',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope-fzf-native.nvim',
            'tom-anders/telescope-vim-bookmarks.nvim',
            'MattesGroeger/vim-bookmarks',
        },
        config = function()
            require("telescope").setup({
                defaults = {
                    vimgrep_arguments = {
                        "rg",
                        "--color=never",
                        "--no-heading",
                        "--with-filename",
                        "--line-number",
                        "--column",
                        "--smart-case",
                        "--hidden",
                        "--trim" -- add this value
                    },
                }
            })

            local builtin = require('telescope.builtin')
            local n = function(l, r)
                vim.keymap.set("n", l, r, { silent = true })
            end


            local project_files = function()
                local opts = {} -- define here if you want to define something
                vim.fn.system('git rev-parse --is-inside-work-tree')
                if vim.v.shell_error == 0 then
                    builtin.git_files(opts)
                else
                    builtin.find_files(opts)
                end
            end

            n('<C-p>', project_files)
            n('<leader>p', function()
                builtin.find_files({ no_ignore = true, hidden = true })
            end)
            n('<leader><leader>a', function()
                builtin.live_grep({ glob_pattern = '!.git/*' })
            end)
            n('<leader>fb', builtin.buffers)
            n('<leader>rp', builtin.grep_string)

            n('<leader><leader>p', builtin.resume)

            n('<leader>ll', builtin.lsp_dynamic_workspace_symbols)

            local search_lsp_symbols = function(symbol)
                return function()
                    builtin.lsp_dynamic_workspace_symbols({ symbols = symbol })
                end
            end

            n('<leader>lf', search_lsp_symbols("function"))
            n('<leader>lm', search_lsp_symbols("method"))
            n('<leader>lv', search_lsp_symbols("variable"))

            require('telescope').load_extension('vim_bookmarks')

            local extensions = require('telescope').extensions

            n('<leader>m', function()
                extensions.vim_bookmarks.all {
                    attach_mappings = function(_, map)
                        map('n', 'dd', extensions.vim_bookmarks.actions.delete_selected_or_at_cursor)
                        return true
                    end
                }
            end)

            local v = function(l, r)
                vim.keymap.set("v", l, r, { silent = true })
            end

            function vim.getVisualSelection()
                vim.cmd('noau normal! "vy"')
                local text = vim.fn.getreg('v')
                vim.fn.setreg('v', {})

                text = string.gsub(text, "\n", "")
                if #text > 0 then
                    return text
                else
                    return ''
                end
            end

            v("<leader>*", function()
                builtin.live_grep({ default_text = vim.getVisualSelection() })
            end)
        end
    },
    {
        'nvim-telescope/telescope-fzf-native.nvim',
        build =
            'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release &&' ..
            'cmake --build build --config Release &&' ..
            'cmake --install build --prefix build'
    },
    'tpope/vim-abolish', -- Search and replace
}
