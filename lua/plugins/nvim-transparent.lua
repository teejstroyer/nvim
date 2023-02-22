return {
	"xiyaowong/nvim-transparent",
	enabled = false,
	config = function()
		require("transparent").setup({
			enable = true, -- boolean: enable transparent
			extra_groups = { "all" },
			exclude = {}, -- table: groups you don't want to clear
		})
	end,
}
