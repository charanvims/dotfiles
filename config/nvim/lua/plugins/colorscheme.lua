return {
  {
    "sainnhe/everforest",
    lazy = false,
    priority = 1000,
    config = function()
      -- Select dark mode and medium contrast
      vim.o.background = "dark"
      vim.g.everforest_background = "hard"

      -- Optional tweaks
      vim.g.everforest_enable_italic = false
      vim.g.everforest_better_performance = 1

      -- Apply colorscheme
      vim.cmd.colorscheme("everforest")
    end,
  },
}
