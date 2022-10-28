require('impatient').enable_profile()
vim.notify = require("notify")
require('nightfox').setup({
    options = {
        styles = {
            comments = "italic",
            keywords = "bold",
            types = "italic,bold",
        }
    }
})

require("nvim-autopairs").setup()
require('gitsigns').setup()
require('nvim-tree').setup()
require('lualine').setup({ options = { theme = 'nightfox' } })
require("which-key").setup()
require('nvim-treesitter.configs').setup({
    ensure_installed = { "c", "lua", "rust", "c_sharp" },
    sync_install = false,
    highlight = {
        enable = true,
    }
})
require("telescope").setup {
    extensions = {
        ["ui-select"] = {
            require("telescope.themes").get_dropdown()
        }
    }
}
require("telescope").load_extension("ui-select")
require("telescope").load_extension("notify")
