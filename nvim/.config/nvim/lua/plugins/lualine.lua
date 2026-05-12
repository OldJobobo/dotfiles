return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      opts.options = opts.options or {}
      opts.options.theme = "auto" -- use active colorscheme palette
      opts.options.component_separators = { left = "", right = "" }
      opts.options.section_separators = { left = "  ", right = "" }

      opts.sections = opts.sections or {}

      -- opts.sections.lualine_a = opts.sections.lualine_a or {}
      -- if type(opts.sections.lualine_a[1]) == "string" and opts.sections.lualine_a[1] == "mode" then
      --   opts.sections.lualine_a[1] = { "mode", color = function() return { fg = get_theme_main_bg() } end }
      -- end
      --
      -- opts.sections.lualine_z = opts.sections.lualine_z or {}
      -- if type(opts.sections.lualine_z[1]) == "function" then
      --   opts.sections.lualine_z[1] = { opts.sections.lualine_z[1], color = function() return { fg = get_theme_main_bg() } end }
      -- end

      opts.sections.lualine_b = {
        "branch",
        {
          "diagnostics",
          sources = { "nvim_diagnostic" },
          symbols = { error = " ", warn = " ", info = " " },
          -- diagnostics_color = {
          --   error = { fg = "#151515" },
          --   warn = { fg = "#151515" },
          --   info = { fg = "#151515" },
          -- },
        },
      }
      opts.sections.lualine_x = {
        { "encoding", padding = { left = 1, right = 1 }, separator = { left = "░▒▓" } },
        { "fileformat" },
        { "filetype" },
      }
      opts.sections.lualine_y = { "searchcount", "progress" }
    end,
  },
}
