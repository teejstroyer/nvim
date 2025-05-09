local presets = require("markview.presets");
require("markview").setup({
  markdown = {
    headings = presets.headings.arrowed,
    horizontal_rules = presets.horizontal_rules.solid,
    tables = presets.tables.rounded
  },
  preview = {
    hybrid_modes = { "n", "v" },
    edit_range = { 1, 1 }
  }
})
