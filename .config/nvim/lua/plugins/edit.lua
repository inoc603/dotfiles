return {
    'tpope/vim-sensible',

    -- More text objects
    'wellle/targets.vim',

    {
        'nathanaelkane/vim-indent-guides',
        config = function()
            -- Indent guide
            vim.g.indent_guides_start_level = 2
            vim.g.indent_guides_guide_size = 1
        end
    },

    -- Auto pairs parenthesis
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = true
        -- use opts = {} for passing setup options
        -- this is equivalent to setup({}) function
    },
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {
            modes = {
                search = {
                    enabled = false
                },
                char = {
                    enabled = false
                },
            },
        },
        keys = {
            {
                "<leader>s",
                mode = { "n", "x", "o" },
                function() require("flash").jump() end,
                desc = "Flash",
            }
        },
    },

    -- Edit surrounds with ease
    'tpope/vim-surround',

    -- Multicursor editing
    {
        'terryma/vim-multiple-cursors',
        config = function()
            vim.g.multi_cursor_exit_from_insert_mode = 0
        end
    },

    -- Code alignment
    {
        'junegunn/vim-easy-align',
        config = function()
            vim.keymap.set({ "n", "v" }, "ga", "<Plug>(EasyAlign)")
        end
    },

    -- Editorconfig
    'editorconfig/editorconfig-vim',

    -- Visual color codes
    {
        'norcalli/nvim-colorizer.lua',
        config = function()
            require('colorizer').setup()
        end,
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {
            scope = {
                show_start = false,
                show_end = false,
            },
        }
    }
}
