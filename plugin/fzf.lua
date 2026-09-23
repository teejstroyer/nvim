-- ===========================================================================
-- FZF & Task Runner (Overseer)
-- ===========================================================================

vim.pack.add({
  'https://github.com/ibhagwan/fzf-lua',
  'https://github.com/elanmed/fzf-lua-frecency.nvim',
  'https://github.com/stevearc/overseer.nvim',
})

local fzf = require('fzf-lua')
local fzfr = require('fzf-lua-frecency')
fzf.register_ui_select()

vim.keymap.set("n", "<leader>F", ":FzfLua<CR>", { desc = "FZF Lua" })
vim.keymap.set("n", "<leader>ff", fzf.files, { desc = "Find files" })
vim.keymap.set("n", "<leader><space>", function() fzfr.frecency({ cwd_only = true }) end, { desc = "Find files (frecency)" })
vim.keymap.set("n", "<leader>fc", fzf.commands, { desc = "Find commands" })
vim.keymap.set("n", "<leader>fb", fzf.buffers, { desc = "Find buffers" })
vim.keymap.set("n", "<leader>fg", fzf.live_grep, { desc = "Find grep" })
vim.keymap.set("n", "<leader>fh", fzf.helptags, { desc = "Find helptags" })
vim.keymap.set("n", "<leader>fd", fzf.diagnostics_document, { desc = "Find diagnostics_document" })
vim.keymap.set("n", "<leader>fD", fzf.diagnostics_workspace, { desc = "Find diagnostics_workspace" })
vim.keymap.set("n", "<leader>fr", fzf.resume, { desc = "Find resume" })
vim.keymap.set("n", "<leader>/", fzf.lines, { desc = "Find lines" })

local overseer = require("overseer")
overseer.setup()
overseer.enable_dap()

overseer.add_template_hook({}, function(task_defn, util)
  util.add_component(task_defn, {
    "open_output",
    on_start = "always",
    focus = false,
  })
end)

local maven_templates = {
  { name = "Maven: clean",                      cmd = { "mvn", "clean" } },
  { name = "Maven: install",                    cmd = { "mvn", "install" } },
  { name = "Maven: clean install",              cmd = { "mvn", "clean", "install" } },
  { name = "Maven: clean install (skip tests)", cmd = { "mvn", "clean", "install", "-DskipTests" } },
  { name = "Maven: test",                       cmd = { "mvn", "test" } },
  { name = "Maven: package",                    cmd = { "mvn", "package" } },
  { name = "Maven: verify",                     cmd = { "mvn", "verify" } },
  { name = "Maven: spring-boot:run",            cmd = { "mvn", "spring-boot:run" } },
}

local dotnet_templates = {
  { name = "Dotnet: build",   cmd = { "dotnet", "build" } },
  { name = "Dotnet: run",     cmd = { "dotnet", "run" } },
  { name = "Dotnet: test",    cmd = { "dotnet", "test" } },
  { name = "Dotnet: clean",   cmd = { "dotnet", "clean" } },
  { name = "Dotnet: publish", cmd = { "dotnet", "publish" } },
  { name = "Dotnet: restore", cmd = { "dotnet", "restore" } },
}

local gradle_templates = {
  { name = "Gradle: build",       cmd = { "./gradlew", "build" } },
  { name = "Gradle: clean",       cmd = { "./gradlew", "clean" } },
  { name = "Gradle: clean build", cmd = { "./gradlew", "clean", "build" } },
  { name = "Gradle: test",        cmd = { "./gradlew", "test" } },
  { name = "Gradle: bootRun",     cmd = { "./gradlew", "bootRun" } },
  { name = "Gradle: assemble",    cmd = { "./gradlew", "assemble" } },
  { name = "Gradle: check",       cmd = { "./gradlew", "check" } },
}

local tool_template_map = {
  { templates = dotnet_templates, condition = { filetype = { "cs" } } },
  { templates = maven_templates,  condition = { filetype = { "java", "xml" } } },
  { templates = gradle_templates, condition = { filetype = { "java", "kotlin", "groovy" } } },
}

for _, group in ipairs(tool_template_map) do
  for _, t in ipairs(group.templates) do
    local cmd = t.cmd
    overseer.register_template({
      name = t.name,
      condition = group.condition,
      builder = function() return { cmd = cmd, cwd = vim.g.launch_cwd } end,
    })
  end
end

vim.keymap.set("n", "<leader>r", overseer.run_task, { desc = "RUN: Task" })
vim.keymap.set("n", "<leader>R", overseer.toggle, { desc = "RUN: Toggle UI" })
