return {
    {
        'EdenEast/nightfox.nvim',
        name = "nightfox",
        config = function()
            vim.cmd('colorscheme nightfox')
        end
    },
    'nvim-treesitter/playground',
    'mbbill/undotree',
    { 'akinsho/bufferline.nvim', tag = "v3.*", dependencies = 'nvim-tree/nvim-web-devicons' }
}
