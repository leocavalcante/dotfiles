return {
       {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        dependencies = {
            {'williamboman/mason.nvim'},
            {'williamboman/mason-lspconfig.nvim'},
        },
        config = function()
            local lsp_zero = require('lsp-zero')
            lsp_zero.extend_lspconfig()
            lsp_zero.on_attach(function(client, bufnr)
                lsp_zero.default_keymaps({buffer = bufnr})
            end)

            require('mason').setup({})
            require('mason-lspconfig').setup({
                ensure_installed = {'lua_ls', 'phpactor', 'marksman', 'gopls'},
                handlers = {
                    function(server_name)
                         require('lspconfig')[server_name].setup({})
                    end,
                },
            })

            require('lspconfig').gopls.setup({
                on_attach = function (client, bufnr)
                    autocmd("BufWritePre", {
                        pattern = "*.go", callback = function()
                            local params = vim.lsp.util.make_range_params()
                            params.context = {only = {"source.organizeImports"}}
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
                            vim.lsp.buf.format({async = false})
                        end
                    })
                end,
            })
        end
    },
    {'neovim/nvim-lspconfig'},
    {'hrsh7th/cmp-nvim-lsp'},
    {'hrsh7th/nvim-cmp'},
    {'L3MON4D3/LuaSnip'},
}
