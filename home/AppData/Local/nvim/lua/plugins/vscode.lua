-- VScode Config
--

return {
  -- add vscode multi-cursor
  {
    "vscode-neovim/vscode-multi-cursor.nvim",
    event = "VeryLazy",
    cond = not not vim.g.vscode,
    opts = {},
    keys = {
      {
        "<C-g>",
        mode = { "n", "x", "i" },
        function()
          require("vscode-multi-cursor").addSelectionToNextFindMatch()
        end,
      },
    },
  },
}
