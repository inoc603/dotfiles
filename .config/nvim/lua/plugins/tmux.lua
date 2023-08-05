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
    }
}
