-- Keep Omarchy theme switching dynamic while stow manages this file.
local theme_file = vim.fn.expand("~/.config/omarchy/current/theme/neovim.lua")

if vim.uv.fs_stat(theme_file) then
  return dofile(theme_file)
end

return {}
