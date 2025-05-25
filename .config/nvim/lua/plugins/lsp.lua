return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end
    },


    {
        "folke/trouble.nvim",
        config = function()
            require("trouble").setup({})
        end

    },
    {
        'simrat39/symbols-outline.nvim',
        config = function()
            require("symbols-outline").setup()
        end
    },

    {
        'neovim/nvim-lspconfig',
        dependencies = {
            "nvimtools/none-ls.nvim",
            'folke/trouble.nvim',
            'saghen/blink.cmp',
            'simrat39/symbols-outline.nvim',
        },
        config = function()
            local trouble = require("trouble")

            -- Use an on_attach function to only map the following keys
            -- after the language server attaches to the current buffer
            local on_attach = function(_, bufnr)
                vim.api.nvim_create_autocmd("BufWritePre", {
                    buffer = bufnr,
                    callback = function()
                        vim.lsp.buf.format { async = false }
                    end
                })

                local opts = { buffer = bufnr }

                -- format the file
                vim.keymap.set("n", '<leader>f', function() vim.lsp.buf.format { timeout_ms = 5000 } end, opts)
                -- open floating window at cursor
                vim.keymap.set("n", '<leader>e', vim.diagnostic.open_float, opts)
                -- go to the next diagnostic
                vim.keymap.set("n", '<leader>k', vim.diagnostic.goto_next, opts)
                -- go to the previous diagnostic
                vim.keymap.set("n", '<leader>j', vim.diagnostic.goto_prev, opts)
                -- go to type definition
                vim.keymap.set("n", 'gD', vim.lsp.buf.type_definition, opts)
                -- go to definition
                vim.keymap.set("n", 'gd', vim.lsp.buf.definition, opts)
                -- show document for object at the current position
                vim.keymap.set("n", 'K', vim.lsp.buf.hover, opts)
                -- rename the object at the current opsition
                vim.keymap.set("n", '<leader>rn', vim.lsp.buf.rename, opts)
                -- bring up code actions for the current position
                vim.keymap.set("n", '<leader>ca', vim.lsp.buf.code_action, opts)


                local open = function(mode)
                    return function()
                        trouble.open({ mode = mode })
                    end
                end

                -- show references for the current object
                vim.keymap.set("n", 'gr', open("lsp_references"), opts)
                -- show implementations for the current interface
                vim.keymap.set("n", 'gi', open("lsp_implementations"), opts)
                -- show all diagnostics
                vim.keymap.set("n", '<leader>d', open("document_diagnostics"), opts)
                vim.keymap.set("n", '<leader>D', open("workspace_diagnostics"), opts)
                -- close the trouble window
                vim.keymap.set("n", '<leader><leader>d', trouble.close, opts)
            end

            -- local lsp = require('lspconfig')

            local function setup(server, server_opts)
                if not server_opts.on_attach then
                    server_opts.on_attach = on_attach
                end
                server_opts.flags = {
                    -- this is the default in Nvim 0.7+
                    debounce_text_changes = 150,
                }

                server_opts.capabilities = require('blink.cmp').get_lsp_capabilities(server_opts.capabilities)
                -- lsp[server].setup(server_opts)
                vim.lsp.config(server, server_opts)
                vim.lsp.enable(server)
            end

            local null_ls = require("null-ls")
            null_ls.setup({
                on_attach = on_attach,
            })

            setup("ts_ls", {
                on_attach = function(client, bufnr)
                    client.server_capabilities.documentFormattingProvider = false
                    client.server_capabilities.documentRangeFormattingProvider = false
                    on_attach(_, bufnr)

                    vim.keymap.set("n", '<leader><leader>f', function()
                        local params = {
                            command = "_typescript.organizeImports",
                            arguments = { vim.api.nvim_buf_get_name(0) },
                            title = ""
                        }
                        vim.lsp.buf.execute_command(params)
                    end, { buffer = bufnr })
                end
            })

            setup("yamlls", {
                settings = {
                    yaml = {
                        format = { enable = true },
                        schemaStore = {
                            url = "https://www.schemastore.org/api/json/catalog.json",
                            enable = true,
                        }
                    }
                }
            })

            vim.g.rustaceanvim = {
                -- Plugin configuration
                tools = {},
                -- LSP configuration
                server = {
                    on_attach = on_attach,
                    default_settings = {
                        ['rust-analyzer'] = {},
                    },
                },
                -- DAP configuration
                dap = {},
            }

            -- setup("rust_analyzer", {
            --     settings = {
            --         ["rust-analyzer"] = {}
            --     }
            -- })

            setup("lua_ls", {
                settings = {
                    Lua = {
                        runtime = {
                            version = 'LuaJIT',
                        },
                        diagnostics = {
                            globals = {
                                'vim', -- neovim
                                'hs'   -- hammerspoon
                            },
                        },
                        workspace = {
                            -- Make the server aware of Neovim runtime files
                            library = vim.api.nvim_get_runtime_file("", true),
                            checkThirdParty = false,
                        },
                        telemetry = {
                            enable = false,
                        },
                        format = {
                            enable = true,
                            -- NOTE: the value should be STRING!!
                            defaultConfig = {
                                indent_style = "space",
                                indent_size = "4",
                            }
                        },
                    },
                },
            })

            setup("gopls", {
                -- cmd = { "gopls", "-remote=auto" },
                cmd = { "gopls" },
                settings = {
                    gopls = {
                        analyses = {
                            unusedparams = true,
                        },
                        staticcheck = true,
                        gofumpt = true,
                    },
                },
            })

            setup("graphql", {})


            setup("basedpyright", {
                -- capabilities = pylance_caps,
                on_attach = function(_, bufnr)
                    on_attach(_, bufnr)

                    -- calls ruff fix all
                    vim.keymap.set("n", '<leader><leader>f', function()
                        vim.lsp.buf.code_action({
                            filter = function(action)
                                return action.title == "Ruff: Fix all auto-fixable problems"
                            end,
                            apply = true,
                        })
                    end, { buffer = bufnr })

                    -- select venv when connected.
                    -- require('venv-selector').retrieve_from_cache()
                end,
                settings = {
                    basedpyright = {
                        analysis = {
                            typeCheckingMode = "basic",
                            diagnosticSeverityOverrides = {
                                reportAny = false,
                                reportUnknownMemberType = false,
                                reportUnknownArgumentType = false,
                                reportArgumentType = false,
                                reportUnknownVariableType = false,
                                -- reportUnusedClass = "warning",
                                -- reportUnusedFunction = "warning",
                                reportUndefinedVariable = false, -- ruff handles this with F822
                                reportUnusedImport = false,      -- ruff F401
                            }
                        },
                    }
                }
            })

            setup("ruff", {})

            setup("zls", {})

            setup("buf_ls", {})

            setup("helm_ls", {})

            setup("terraformls", {})
        end
    },

    {
        'stevearc/dressing.nvim',
        config = function()
            require('dressing').setup {
                input = {
                    win_options = {
                        winblend = 0,
                    }
                }
            }
        end
    },
}
