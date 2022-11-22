require('impatient').enable_profile()
require('nightfox').setup({
    options = {
        styles = {
            comments = "italic",
            keywords = "bold",
            types = "italic,bold",
        }
    }
})

require("noice").setup({
  lsp = {
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
  },
  -- you can enable a preset for easier configuration
  presets = {
    bottom_search = true, -- use a classic bottom cmdline for search
    command_palette = true, -- position the cmdline and popupmenu together
    long_message_to_split = true, -- long messages will be sent to a split
    inc_rename = false, -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = false, -- add a border to hover docs and signature help
  },
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
--require("telescope").load_extension("notify")
