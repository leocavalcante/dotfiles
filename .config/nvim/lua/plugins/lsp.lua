return {
    {
        'williamboman/mason.nvim',
        dependencies = {
            'williamboman/mason-lspconfig.nvim',
            'neovim/nvim-lspconfig',
            'hrsh7th/cmp-nvim-lsp',
        },
        config = function()
            -- Pass cmp capabilities to all servers
            local capabilities = require('cmp_nvim_lsp').default_capabilities()
            vim.lsp.config('*', { capabilities = capabilities })

            -- Default keymaps on LSP attach
            vim.api.nvim_create_autocmd('LspAttach', {
                callback = function(event)
                    local bufnr = event.buf
                    local function map(mode, lhs, rhs)
                        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr })
                    end
                    map('n', 'K', vim.lsp.buf.hover)
                    map('n', 'gd', vim.lsp.buf.definition)
                    map('n', 'gD', vim.lsp.buf.declaration)
                    map('n', 'gi', vim.lsp.buf.implementation)
                    map('n', 'go', vim.lsp.buf.type_definition)
                    map('n', 'gr', vim.lsp.buf.references)
                    map('n', 'gs', vim.lsp.buf.signature_help)
                    map('n', '<F2>', vim.lsp.buf.rename)
                    map({'n', 'x'}, '<F3>', function() vim.lsp.buf.format({ async = false }) end)
                    map('n', '<F4>', vim.lsp.buf.code_action)
                    map('n', 'gl', vim.diagnostic.open_float)
                    map('n', '[d', vim.diagnostic.goto_prev)
                    map('n', ']d', vim.diagnostic.goto_next)
                end,
            })

            -- Organize Go imports on save
            vim.lsp.config('gopls', {
                on_attach = function(client, bufnr)
                    vim.api.nvim_create_autocmd('BufWritePre', {
                        buffer = bufnr,
                        callback = function()
                            local params = vim.lsp.util.make_range_params()
                            params.context = { only = { 'source.organizeImports' } }
                            local result = vim.lsp.buf_request_sync(0, 'textDocument/codeAction', params)
                            for cid, res in pairs(result or {}) do
                                for _, r in pairs(res.result or {}) do
                                    if r.edit then
                                        local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or 'utf-16'
                                        vim.lsp.util.apply_workspace_edit(r.edit, enc)
                                    end
                                end
                            end
                            vim.lsp.buf.format({ async = false })
                        end,
                    })
                end,
            })

            require('mason').setup({})
            require('mason-lspconfig').setup({
                ensure_installed = {
                    'lua_ls',
                    'phpactor',
                    'marksman',
                    'gopls',
                    'ts_ls',
                    'pylsp',
                    'rust_analyzer',
                    'yamlls',
                    'jsonls',
                },
                handlers = {
                    function(server_name)
                        vim.lsp.enable(server_name)
                    end,
                },
            })
        end
    },
    {'neovim/nvim-lspconfig'},
    {'hrsh7th/cmp-nvim-lsp'},
    {'hrsh7th/nvim-cmp'},
    {'L3MON4D3/LuaSnip'},
}
