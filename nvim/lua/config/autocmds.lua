-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Follow the macOS light/dark appearance.
-- Neovim asks the terminal for its background at startup, but not again when it
-- changes under a running instance, so an open editor would keep the old side
-- after a switch. Re-check whenever the window regains focus; vim.system is async,
-- so nothing blocks on the `defaults` call.
if vim.fn.has("mac") == 1 then
  local function sync_background()
    vim.system({ "defaults", "read", "-g", "AppleInterfaceStyle" }, { text = true }, function(out)
      local want = (out.stdout or ""):match("Dark") and "dark" or "light"
      vim.schedule(function()
        if vim.o.background ~= want then
          vim.o.background = want
          pcall(vim.cmd.colorscheme, "modus")
        end
      end)
    end)
  end

  vim.api.nvim_create_autocmd({ "FocusGained", "VimResume" }, {
    group = vim.api.nvim_create_augroup("follow_macos_appearance", { clear = true }),
    callback = sync_background,
  })
end
