return {
  'feline-nvim/feline.nvim',
  config = function()
    require('feline').setup()
    require('feline').winbar.setup()
  end
}
