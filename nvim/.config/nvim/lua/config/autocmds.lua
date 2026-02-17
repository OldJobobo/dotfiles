-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.filetype.add({
  extension = {
    gtkcss = "gtkcss",
  },
  filename = {
    ["gtk.css"] = "gtkcss",
    ["gtk-dark.css"] = "gtkcss",
    ["settings.css"] = "gtkcss",
  },
  pattern = {
    [".*/gtk%-3%.0/.*%.css"] = "gtkcss",
    [".*/gtk%-4%.0/.*%.css"] = "gtkcss",
    [".*/waybar/.*%.css"] = "gtkcss",
    [".*/swayosd/.*%.css"] = "gtkcss",
    [".*/walker/.*%.css"] = "gtkcss",
    [".*/waybar%.css"] = "gtkcss",
    [".*/swayosd%.css"] = "gtkcss",
    [".*/gtk%.css"] = "gtkcss",
    [".*/walker%.css"] = "gtkcss",
    [".*/hyprland%-preview%-share%-picker%.css"] = "gtkcss",
  },
})

-- Reuse CSS highlighting/parser for gtkcss buffers while keeping gtkcss filetype for LSP.
pcall(function()
  vim.treesitter.language.register("css", "gtkcss")
end)

vim.api.nvim_create_autocmd("FileType", {
  pattern = "gtkcss",
  callback = function()
    vim.bo.syntax = "css"
  end,
})

vim.api.nvim_create_user_command("HelloWorld", function()
  require("hello").hello()
end, {})
