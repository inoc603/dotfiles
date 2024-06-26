return {
    {
        'kyazdani42/nvim-tree.lua',
        event = "VeryLazy",
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
            nnoremap("<c-\\>", function()
                require("nvim-tree.api").tree.toggle()
                -- The highlight group is somehow reset when first the tree
                -- is toggled for the first time. Manually link the highlight
                -- groups so the color doesn't look odd.
                vim.cmd [[
                    highlight! link NvimTreeNormal Normal
                ]]
                vim.cmd [[
                    highlight! link NvimTreeEndOfBuffer Conceal
                ]]
            end)
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
    },

    {
        'stevearc/oil.nvim',
        opts = {},
        config = function()
            require("oil").setup()
        end,
        -- Optional dependencies
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },

}
