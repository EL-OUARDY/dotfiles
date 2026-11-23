-- ~/.config/nvim/lua/plugins/colorscheme.lua
return {
  -- Official Catppuccin plugin, Mocha flavour
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      flavour = "mocha",
      term_colors = true, -- Catppuccin colours in Neovim's built-in terminal too
      transparent_background = false, -- set to true if you enable Ghostty's glass look
    },
  },
  -- Tell LazyVim to use it. Use "catppuccin-mocha", not "catppuccin":
  -- Neovim 0.12 ships its own, unrelated "catppuccin" scheme under that name.
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "catppuccin-mocha" },
  },
}
