return {
  "folke/snacks.nvim",
  opts = {
    explorer = {
      replace_netrw = true,
    },
  },
  init = function()
    vim.api.nvim_create_autocmd("VimEnter", {
      group = vim.api.nvim_create_augroup("lazyvim_auto_explorer", { clear = true }),
      callback = function()
        -- replace_netrw already opens the explorer for `nvim <directory>`
        local arg = vim.fn.argv(0)
        if arg ~= "" and vim.fn.isdirectory(arg) == 1 then
          return
        end
        if #Snacks.picker.get({ source = "explorer" }) > 0 then
          return
        end
        Snacks.explorer({ cwd = LazyVim.root(), enter = false })
      end,
    })
  end,
}
