return {
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            -- add any options here
        },
        dependencies = {
            -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
            "MunifTanjim/nui.nvim",
            -- OPTIONAL:
            --   `nvim-notify` is only needed, if you want to use the notification view.
            --   If not available, we use `mini` as the fallback
            -- "rcarriga/nvim-notify",
        }
    },
    {
        "sainnhe/gruvbox-material",
        priority = 1000,
        config = function()
            vim.g.gruvbox_material_foreground = 'original'
            vim.g.gruvbox_material_background = 'medium'
            vim.g.gruvbox_material_visual = 'blue background'
            vim.g.gruvbox_material_better_performance = 1
            vim.cmd [[
                set termguicolors
                colorscheme gruvbox-material
            ]]
        end
    },
    {
        'nvim-lualine/lualine.nvim',
        config = function()
            local gruvbox = require 'lualine.themes.gruvbox-material'
            -- set the backgroud color of the buffer line and status line in insert
            -- and command mode to the same color as normal mode so they don't flash
            -- that much when switching mode and saving files.
            -- gruvbox.insert.c.bg = gruvbox.normal.c.bg
            -- gruvbox.command.c.bg = gruvbox.normal.c.bg
            -- gruvbox.visual.c.bg = gruvbox.normal.c.bg
            gruvbox.insert.a.bg = gruvbox.normal.a.bg
            gruvbox.command.a.bg = gruvbox.normal.a.bg
            gruvbox.visual.a.bg = gruvbox.normal.a.bg

            require('lualine').setup({
                options = {
                    icons_enabled = false,
                    theme = gruvbox,
                    -- theme = 'gruvbox-material',
                    component_separators = { left = '|', right = '|' },
                    section_separators = { left = ' ', right = ' ' },
                    always_divide_middle = true,
                    globalstatus = false,
                },
                sections = {
                    lualine_a = { 'mode' },
                    lualine_b = { 'branch', 'diff', 'diagnostics' },
                    lualine_c = {
                        { 'filename', path = 1 }, -- relative path
                    },
                    lualine_x = { 'encoding', 'filetype' },
                    lualine_y = {},
                    lualine_z = { 'location' }
                },
                tabline = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = {
                        {
                            'buffers',
                            show_filename_only = false, -- show shortened relative path
                            buffers_color = {
                                active = { fg = gruvbox.normal.a.fg, bg = gruvbox.normal.a.bg },
                                inactive = 'lualine_c_inactive',
                            },
                            symbols = {
                                alternate_file = '', -- don't identify the alternate file
                            },
                        },
                    },
                    lualine_x = {},
                    lualine_y = {},
                    lualine_z = {}
                }
            })
        end
    }
}
