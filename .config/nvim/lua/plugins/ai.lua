return {
    {
        "yetone/avante.nvim",
        event = "VeryLazy",
        lazy = false,
        version = false, -- set this if you want to always pull the latest change
        opts = {
            -- add any opts here
            -- provider = "copilot"
            provider = "openai",
            openai = {
                endpoint = "https://litellmui.ai.gcp-sg.dev.awx.im",
            },
            auto_suggestions_provider = "copilot",
            mappings = {
                ask = "<leader>ua",     -- ask
                edit = "<leader>ue",    -- edit
                refresh = "<leader>ur", -- refresh
            },
        },
        -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
        build = "make",
        -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "stevearc/dressing.nvim",
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            --- The below dependencies are optional,
            "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
            {
                "zbirenbaum/copilot.lua",
                cmd = "Copilot",
                config = function()
                    require("copilot").setup({
                        suggestion = {
                            enabled = true,
                            auto_trigger = false,
                            debounce = 75,
                            keymap = {
                                accept = "¬",
                                accept_word = false,
                                accept_line = false,
                                next = "‘",
                                prev = "“",
                                dismiss = "<C-]>",
                            },
                        },
                    })
                end,
            }, -- provider = copilot
            {
                -- support for image pasting
                "HakonHarnes/img-clip.nvim",
                event = "VeryLazy",
                opts = {
                    -- recommended settings
                    default = {
                        embed_image_as_base64 = false,
                        prompt_for_file_name = false,
                        drag_and_drop = {
                            insert_mode = true,
                        },
                        -- required for Windows users
                        use_absolute_path = true,
                    },
                },
            },
            {
                -- Make sure to set this up properly if you have lazy=true
                'MeanderingProgrammer/render-markdown.nvim',
                opts = {
                    file_types = { "markdown", "Avante" },
                },
                ft = { "markdown", "Avante" },
            },
        }
    }
}
