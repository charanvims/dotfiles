return {
  { "rose-pine/neovim", name = "rose-pine" },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "rose-pine",
    },
  },
  {
    "rose-pine/neovim",
    opts = {
      variant = "moon",
      dark_variant = "moon",
      disable_background = true,
      disable_float_background = true,
      highlight_groups = {
        Normal = { bg = "#000000" },
        NormalNC = { bg = "#000000" },
        SignColumn = { bg = "#000000" },
        LineNr = { bg = "#000000" },
        CursorLineNr = { bg = "#000000" },
        FoldColumn = { bg = "#000000" },
        NormalFloat = { bg = "#000000" },
        FloatBorder = { bg = "#000000" },
      },
    },
  },
}
