return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
        ensure_installed = {
            "lua",
            "go",
            "php",
            "python",
            "typescript",
            "javascript",
            "rust",
            "yaml",
            "json",
            "bash",
        },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
    }
}

