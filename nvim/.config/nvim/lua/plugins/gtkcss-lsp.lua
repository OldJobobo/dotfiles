-- gtkcss-lsp.lua

return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local ok_configs, configs = pcall(require, "lspconfig.configs")
      if not ok_configs then
        return
      end

      local ok_util, util = pcall(require, "lspconfig.util")
      if not ok_util then
        return
      end

      configs.gtkcsslanguageserver = configs.gtkcsslanguageserver
        or {
          default_config = {
            cmd = { "gtkcsslanguageserver" },
            filetypes = { "gtkcss" },
            root_dir = function(fname)
              return util.find_git_ancestor(fname) or vim.loop.cwd()
            end,
            single_file_support = true,
          },
        }

      opts = opts or {}
      opts.servers = opts.servers or {}
      opts.servers.gtkcsslanguageserver = opts.servers.gtkcsslanguageserver or {}
    end,
  },
}
