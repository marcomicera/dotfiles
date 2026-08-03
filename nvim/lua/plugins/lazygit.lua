return {
  "folke/snacks.nvim",
  opts = function(_, opts)
    opts.lazygit = vim.tbl_deep_extend("force", opts.lazygit or {}, {
      -- sync theme with nvim colorscheme; open files in this nvim instance
      configure = true,
    })

    if vim.fn.executable("lazygit") == 1 then
      table.insert(opts.dashboard.preset.keys, 5, {
        icon = "󰊢 ",
        key = "z",
        desc = "Lazygit",
        action = ":lua Snacks.lazygit({ cwd = LazyVim.root.git() })",
      })
    end
  end,
}
