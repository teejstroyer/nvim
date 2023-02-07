return {
    'akinsho/flutter-tools.nvim',
    enabled=false,
    dependencies = {
        { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim'}
    },
    config = function ()
        require("flutter-tools").setup{} -- use defaults
        require("telescope").load_extension("flutter");
    end
}
