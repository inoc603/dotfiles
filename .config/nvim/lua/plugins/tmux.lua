return {
    {
        'aserowy/tmux.nvim',
        config = function()
            return require("tmux").setup({
                copy_sync = {
                    enable = false,
                },
                navigation = {
                    -- cycles to opposite pane while navigating into the border
                    cycle_navigation = true,

                    -- enables default keybindings (C-hjkl) for normal mode
                    enable_default_keybindings = true,

                    -- prevents unzoom tmux when navigating beyond vim border
                    persist_zoom = false,
                },
                resize = {
                    enable_default_keybindings = false,
                }
            })
        end
    },
    -- {
    --     "swaits/zellij-nav.nvim",
    --     lazy = true,
    --     event = "VeryLazy",
    --     keys = {
    --         { "<c-h>", "<cmd>ZellijNavigateLeftTab<cr>",  { silent = true, desc = "navigate left or tab" } },
    --         { "<c-j>", "<cmd>ZellijNavigateDown<cr>",     { silent = true, desc = "navigate down" } },
    --         { "<c-k>", "<cmd>ZellijNavigateUp<cr>",       { silent = true, desc = "navigate up" } },
    --         { "<c-l>", "<cmd>ZellijNavigateRightTab<cr>", { silent = true, desc = "navigate right or tab" } },
    --     },
    --     opts = {},
    -- }
}
