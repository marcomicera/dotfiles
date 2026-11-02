return {
  {
    "miikanissi/modus-themes.nvim",
    priority = 1000,
    opts = {
      -- `auto` picks modus_vivendi or modus_operandi from vim.o.background, so Neovim
      -- follows the same macOS light/dark switch as the terminal.
      style = "auto",
      transparent = true,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "modus",
    },
  },
}
