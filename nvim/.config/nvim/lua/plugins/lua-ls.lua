return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts = opts or {}
      opts.servers = opts.servers or {}
      opts.servers.lua_ls = opts.servers.lua_ls or {}
      opts.servers.lua_ls.settings = opts.servers.lua_ls.settings or {}
      opts.servers.lua_ls.settings.Lua = vim.tbl_deep_extend("force", opts.servers.lua_ls.settings.Lua or {}, {
        diagnostics = {
          globals = { "vim" },
        },
      })
    end,
  },
}
