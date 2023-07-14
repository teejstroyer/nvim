return {
    {
        -- This plugin
        "Zeioth/compiler.nvim",
        cmd = { "CompilerOpen", "CompilerToggleResults" },
        dependencies = { "stevearc/overseer.nvim" },
        config = function(_, opts) require("compiler").setup(opts) end,
    },
    {
        -- The framework we use to run tasks
        "stevearc/overseer.nvim",
        commit = "3047ede61cc1308069ad1184c0d447ebee92d749", -- Recommended to to avoid breaking changes
        cmd = { "CompilerOpen", "CompilerToggleResults" },
        opts = {
            -- Tasks are disposed 5 minutes after running to free resources.
            -- If you need to close a task inmediatelly:
            -- press ENTER in the menu you see after compiling on the task you want to close.
            task_list = {
                direction = "bottom",
                min_height = 25,
                max_height = 25,
                default_detail = 1,
                bindings = {
                    ["q"] = function() vim.cmd("OverseerClose") end,
                },
            },
        },
    }
}
