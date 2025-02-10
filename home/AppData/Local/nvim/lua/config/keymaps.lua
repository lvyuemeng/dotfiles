-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("i", "jj", "<Esc>")

if vim.g.vscode then
  local vscode = require("vscode")

  -- Function to create VSCode keymappings
  local function vscode_map(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.silent = opts.silent ~= false
    vim.keymap.set(mode, lhs, function()
      vscode.action(rhs)
    end, opts)
  end

  -- Buffer navigation
  vscode_map("n", "]b", "workbench.action.nextEditor")
  vscode_map("n", "[b", "workbench.action.previousEditor")
  -- Close buffer
  vscode_map("n", "<leader>bd", "workbench.action.closeActiveEditor")

  -- File operations
  vscode_map("n", "<Leader>w", "workbench.action.files.save")
  vscode_map("n", "<Leader>wa", "workbench.action.files.saveAll")
  vscode_map("n", "<Leader>q", "workbench.action.closeActiveEditor")
  vscode_map("n", "<Leader>e", "workbench.view.explorer")
  vscode_map("n", "<Leader>n", "workbench.action.files.newUntitledFile")
  vscode_map("n", "<Leader>o", "workbench.action.files.openFile")
  vscode_map("n", "<leader>cf", "editor.action.formatDocument")

  -- Code navigation
  vscode_map("n", "gd", "editor.action.revealDefinition")
  vscode_map("n", "gr", "editor.action.goToReferences")
  vscode_map("n", "gi", "editor.action.goToImplementation")
  vscode_map("n", "K", "editor.action.showHover")

  -- Code Action
  vscode_map("n", "<leader>ca", "editor.action.quickFix")
  vscode_map("n", "<leader>rn", "editor.action.rename")

  -- Debugging
  vscode_map("n", "<Leader>dd", "workbench.action.debug.start")
  vscode_map("n", "<Leader>ds", "workbench.action.debug.stop")
  vscode_map("n", "<Leader>do", "workbench.action.debug.stepOver")
  vscode_map("n", "<Leader>di", "workbench.action.debug.stepInto")
  vscode_map("n", "<Leader>du", "workbench.action.debug.stepOut")
end

-- Check if 'pwsh' is executable and set the shell accordingly
if vim.fn.executable("pwsh") == 1 then
  vim.o.shell = "pwsh"
else
  vim.o.shell = "powershell"
end

-- Setting shell command flags
vim.o.shellcmdflag =
  "-NoLogo -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues['Out-File:Encoding']='utf8';"

-- Setting shell redirection
vim.o.shellredir = '2>&1 | %{ "$_" } | Out-File %s; exit $LastExitCode'

-- Setting shell pipe
vim.o.shellpipe = '2>&1 | %{ "$_" } | Tee-Object %s; exit $LastExitCode'

-- Setting shell quote options
vim.o.shellquote = ""
vim.o.shellxquote = ""
