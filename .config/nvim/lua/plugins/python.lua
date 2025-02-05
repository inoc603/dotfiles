return {
    {
        "linux-cultist/venv-selector.nvim",
        branch = "regexp",
        dependencies = {
            "neovim/nvim-lspconfig",
            "nvim-telescope/telescope.nvim",
            "mfussenegger/nvim-dap-python"
        },
        opts = {
            -- Your options go here
            name = {
                "venv",
                ".venv",
            },
            -- auto_refresh = false
            search_venv_managers = false,
            stay_on_this_version = true,
            parents = 0,
        },
        lazy = false,
        config = function()
            require("venv-selector").setup()
            -- vim.api.nvim_create_autocmd("VimEnter", {
            --     desc = "Auto select virtualenv Nvim open",
            --     pattern = "*",
            --     callback = function()
            --         local venv = vim.fn.findfile("pyproject.toml", vim.fn.getcwd() .. ";")
            --         if venv ~= "" then
            --             require("venv-selector").retrieve_from_cache()
            --         end
            --     end,
            --     once = true,
            -- })
        end,
        event = "VeryLazy", -- Optional: needed only if you want to type `:VenvSelect` without a keymapping
        -- keys = { {
        --     -- Keymap to open VenvSelector to pick a venv.
        --     "<leader>vs", "<cmd>:VenvSelect<cr>",
        --     -- Keymap to retrieve the venv from a cache (the one previously used for the same project directory).
        --     "<leader>vc", "<cmd>:VenvSelectCached<cr>"
        -- } }
    }
}
