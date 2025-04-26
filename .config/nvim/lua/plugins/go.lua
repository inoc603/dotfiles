return {
    {
        "ray-x/go.nvim",
        dependencies = {
            "ray-x/guihua.lua",
            "neovim/nvim-lspconfig",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            -- organizeImports and format on save
            vim.api.nvim_create_autocmd("BufWritePre", {
                pattern = "*.go",
                callback = function()
                    local params = vim.lsp.util.make_range_params()
                    params.context = { only = { "source.organizeImports" } }
                    -- buf_request_sync defaults to a 1000ms timeout. Depending on your
                    -- machine and codebase, you may want longer. Add an additional
                    -- argument after params if you find that you have to write the file
                    -- twice for changes to be saved.
                    -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
                    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
                    for cid, res in pairs(result or {}) do
                        for _, r in pairs(res.result or {}) do
                            if r.edit then
                                local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
                                vim.lsp.util.apply_workspace_edit(r.edit, enc)
                            end
                        end
                    end
                    vim.lsp.buf.format({ async = false })
                end
            })

            vim.cmd [[
                  " make package and import red as other keywords.
                  highlight! link goPackage TSKeyword
                  highlight! link goImport TSKeyword
                  " make nil and strings purple as other literal values.
                  highlight! link goPredefinedIdentifiers Purple
                  highlight! link goString Purple
                  highlight! link goRawString Purple
            ]]

            require("go").setup()
        end,
        event = { "CmdlineEnter" },
        ft = { "go", 'gomod' },
        build = ':lua require("go.install").update_all_sync()'
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
        event = "VeryLazy",
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
