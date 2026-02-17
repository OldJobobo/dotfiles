return {
  -- Load all theme plugins but don't apply them
  -- This ensures all colorschemes are available for hot-reloading
  {
    "ribru17/bamboo.nvim",
    lazy = true,
    priority = 1000,
  },
  --[[ {
    "OldJobobo/biscuit-nvim",
    branch = "fix-context-popup-colors",
    name = "biscuit",
    lazy = true,
    priority = 1000,
  }, ]]
  --
  {
    "bjarneo/aether.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "bjarneo/ethereal.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "bjarneo/hackerman.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    priority = 1000,
  },
  {
    "sainnhe/everforest",
    lazy = true,
    priority = 1000,
  },
  {
    "kepano/flexoki-neovim",
    lazy = true,
    priority = 1000,
  },
  {
    "ellisonleao/gruvbox.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "tahayvr/matteblack.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "loctvl842/monokai-pro.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "shaunsingh/nord.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = true,
    priority = 1000,
  },
  {
    "folke/tokyonight.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "dark-orchid/neovim",
    name = "dark-orchid",
    lazy = true,
    priority = 1000,
  },
  {
    "OldJobobo/waffle-cat",
    name = "waffle-cat",
    lazy = true,
    priority = 1000,
  },
  {
    "xero/miasma.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "xero/evangelion.nvim",
    lazy = true,
    priority = 1000,
    opts = {
      overrides = {
        -- remove that orange cursor-word block
        LspReferenceText = { bg = "NONE" },
        LspReferenceRead = { bg = "NONE" },
        LspReferenceWrite = { bg = "NONE" },

        -- OR: use underline instead (comment the bg lines above if you do this)
        -- LspReferenceText  = { underline = true },
        -- LspReferenceRead  = { underline = true },
        -- LspReferenceWrite = { underline = true },
      },
    },
  },
}
