
local function setup_servers()
  require'lspinstall'.setup()
  local servers = require'lspinstall'.installed_servers()
  for _, server in pairs(servers) do

    if server == 'omnisharp' then
        local pid = vim.fn.getpid()
        -- On linux/darwin if using a release build, otherwise under scripts/OmniSharp(.Core)(.cmd)
        local omnisharp_bin = "/usr/local/bin/omnisharp"
        require'lspconfig'.omnisharp.setup{ cmd = { omnisharp_bin, "--languageserver" , "--hostPID", tostring(pid) }; }
    else
        require'lspconfig'[server].setup{}
    end
  end
end

local function coq_setup_servers()
    local coq = require"coq"
    local servers = require'lspinstall'.installed_servers()
    
    for server, config in pairs(servers) do
        --require"lspconfig"[server].setup{coq.lsp_ensure_capabilities()}
       --require'lspconfig'[server].setup{}
    end
end

-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
require'lspinstall'.post_install_hook = function ()
  --cmp_setup_servers() -- reload installed servers
  coq_setup_servers() -- reload installed servers
  vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end


--First Run
--setup_servers() -- reload installed servers
coq_setup_servers()
