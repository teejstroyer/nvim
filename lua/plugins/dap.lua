return {
    'mfussenegger/nvim-dap',
    dependencies = {
        'rcarriga/nvim-dap-ui',    -- Creates a beautiful debugger UI
        'williamboman/mason.nvim', -- Installs the debug adapters for you
        'jay-babu/mason-nvim-dap.nvim',
        -- Add your own debuggers here
        --'leoluz/nvim-dap-go',
    },
    config = function()
        local dap = require 'dap'
        local dapui = require 'dapui'

        require("mason-nvim-dap").setup({
            automatic_setup = true,
            ensure_installed = {},
            handlers = {}
        })
        --require 'mason-nvim-dap'.setup_handlers {}

        -- Dap UI setup
        dapui.setup {
            icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
            controls = {
                icons = {
                    pause = '⏸',
                    play = '▶',
                    step_into = '⏎',
                    step_over = '⏭',
                    step_out = '⏮',
                    step_back = 'b',
                    run_last = '▶▶',
                    terminate = '⏹',
                },
            },
        }

        dap.listeners.after.event_initialized['dapui_config'] = dapui.open
        dap.listeners.before.event_terminated['dapui_config'] = dapui.close
        dap.listeners.before.event_exited['dapui_config'] = dapui.close
        -- Install golang specific config
        --require('dap-go').setup()
    end,
}
