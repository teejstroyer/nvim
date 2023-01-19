return {
    "akinsho/bufferline.nvim",
    tag = "v3.*",
    dependencies = "nvim-tree/nvim-web-devicons" ,
    config =function ()
        require("bufferline").setup()
    end
}
