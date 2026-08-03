local function is_snacks_win(win)
  local ft = vim.api.nvim_get_option_value("filetype", { buf = vim.api.nvim_win_get_buf(win) })
  return ft:match("snacks_") ~= nil
end

local function is_floating_win(win)
  return vim.api.nvim_win_get_config(win).relative ~= ""
end

local function list_normal_wins()
  local wins = {}
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if not is_floating_win(win) and not is_snacks_win(win) then
      wins[#wins + 1] = win
    end
  end
  return wins
end

local function has_floating_win()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if is_floating_win(win) then
      return true
    end
  end
  return false
end

local function close_snacks_wins()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if is_snacks_win(win) then
      pcall(vim.api.nvim_win_close, win, true)
    end
  end
end

return {
  "folke/snacks.nvim",
  opts = {
    explorer = {
      replace_netrw = true,
    },
    picker = {
      sources = {
        explorer = {
          hidden = true,
        },
        grep = {
          hidden = true,
        },
        grep_word = {
          hidden = true,
        },
        grep_buffers = {
          hidden = true,
        },
      },
    },
  },
  init = function()
    local group = vim.api.nvim_create_augroup("lazyvim_auto_explorer", { clear = true })

    vim.api.nvim_create_autocmd("VimEnter", {
      group = group,
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

    -- :q on the last file should quit nvim, not leave the explorer open
    vim.api.nvim_create_autocmd("WinClosed", {
      group = group,
      callback = function()
        vim.schedule(function()
          -- Pickers (find files, grep, etc.) are floating; don't quit while one is open
          if #list_normal_wins() == 0 and not has_floating_win() then
            pcall(vim.cmd, "qa!")
          end
        end)
      end,
    })

    -- :q on the explorer when it is the only window left
    vim.api.nvim_create_autocmd("QuitPre", {
      group = group,
      callback = function()
        if is_floating_win(vim.api.nvim_get_current_win()) then
          return
        end
        local windows = vim.api.nvim_list_wins()
        local snacks_wins, floating_wins = {}, {}
        for _, win in ipairs(windows) do
          if is_snacks_win(win) then
            snacks_wins[#snacks_wins + 1] = win
          elseif is_floating_win(win) then
            floating_wins[#floating_wins + 1] = win
          end
        end
        if #windows - #floating_wins - #snacks_wins <= 1 then
          close_snacks_wins()
        end
      end,
    })
  end,
}
