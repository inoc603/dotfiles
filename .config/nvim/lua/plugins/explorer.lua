return {
    {
        'kyazdani42/nvim-tree.lua',
        dependencies = { 'kyazdani42/nvim-web-devicons' },
        config = function()
            require("nvim-tree").setup {
                filters = {
                    custom = { '^.git$' }
                },
                renderer = {
                    highlight_git = true,
                },
                actions = {
                    open_file = {
                        window_picker = {
                            enable = false,
                        },
                    }
                },
                view = {
                    float = {
                        enable = false,
                        open_win_config = {
                            relative = "editor",
                            border = "rounded",
                            width = 30,
                            height = 30,
                            row = 0.5,
                            col = 0.5,
                        }
                    }
                }
            }

            local function keymap(mode, opts)
                return function(key, f)
                    vim.keymap.set(mode, key, f, opts)
                end
            end

            local nnoremap = keymap("n", { noremap = true, silent = true })
            nnoremap("<c-\\>", require("nvim-tree.api").tree.toggle)
        end
    },

    {
        'kazhala/close-buffers.nvim',
        config = function()
            local close_buffers = require("close_buffers")
            close_buffers.setup({})

            -- :Bdi to wipe all hidden buffer
            vim.api.nvim_create_user_command('Bdi', function()
                close_buffers.wipe({ type = 'hidden' })
            end, { force = true })
        end
    }
}
