return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
        ensure_installed = { "lua" },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
    }
}

