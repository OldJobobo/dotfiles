return {
  {
    name = "checktime-fallback",
    dir = vim.fn.stdpath("config"),
    lazy = false,
    priority = 900,
    config = function()
      vim.opt.autoread = true
      vim.opt.updatetime = 300

      local group = vim.api.nvim_create_augroup("omarchy_checktime_fallback", { clear = true })

      vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI", "TermLeave" }, {
        group = group,
        pattern = "*",
        desc = "Check for external file changes when focus events are unreliable (e.g. inside tmux)",
        callback = function()
          if vim.fn.mode() == "c" then
            return
          end

          pcall(vim.cmd, "checktime")
        end,
      })
    end,
  },
}
