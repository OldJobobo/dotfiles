--[[
Top 100+ Themes for nvim on Omarchy
Author: OldJobobo (https://github.com/OldJobobo)
]]

return {
  -- Load all theme plugins but don't apply them
  -- This ensures all colorschemes are available for hot-reloading
  {
    "ribru17/bamboo.nvim",
    opts = {},
    lazy = true,
    priority = 1000,
  },
  {
    "OldJobobo/retro-82.nvim",
    name = "retro-82",
    lazy = true,
    priority = 1000,
  },
  {
    "OldJobobo/biscuit-nvim",
    name = "biscuit",
    lazy = true,
    priority = 1000,
  },
  {
    "Mofiqul/dracula.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "dracula/vim",
    name = "dracula-vim",
    lazy = true,
    priority = 1000,
  },
  {
    "bjarneo/ash.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "bjarneo/vantablack.nvim",
    lazy = true,
    priority = 1000,
  },
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
    "sainnhe/edge",
    lazy = true,
    priority = 1000,
  },
  {
    "sainnhe/gruvbox-material",
    lazy = true,
    priority = 1000,
  },
  {
    "sainnhe/sonokai",
    lazy = true,
    priority = 1000,
  },
  {
    "neanias/everforest-nvim",
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
    "luisiacc/gruvbox-baby",
    lazy = true,
    priority = 1000,
  },
  {
    "EdenEast/nightfox.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "bluz71/vim-moonfly-colors",
    lazy = true,
    priority = 1000,
  },
  {
    "bluz71/vim-nightfly-colors",
    lazy = true,
    priority = 1000,
  },
  {
    "projekt0n/github-nvim-theme",
    lazy = true,
    priority = 1000,
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "scottmckendry/cyberdream.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "marko-cerovac/material.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "mhartington/oceanic-next",
    lazy = true,
    priority = 1000,
  },
  {
    "olimorris/onedarkpro.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "tomasiser/vim-code-dark",
    lazy = true,
    priority = 1000,
  },
  {
    "AlexvZyl/nordic.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "tahayvr/matteblack.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "gthelding/monokai-pro.nvim",
    name = "monokai-pro-gthelding",
    config = function()
      require("monokai-pro").setup()
    end,
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
    "Mofiqul/vscode.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "savq/melange-nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "fenetikm/falcon",
    lazy = true,
    priority = 1000,
  },
  {
    "embark-theme/vim",
    name = "embark-vim",
    lazy = true,
    priority = 1000,
  },
  {
    "rmehri01/onenord.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "everviolet/nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "slugbyte/lackluster.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "ramojus/mellifluous.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "uloco/bluloco.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "mellow-theme/mellow.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "zenbones-theme/zenbones.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "craftzdog/solarized-osaka.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "navarasu/onedark.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "eldritch-theme/eldritch.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "baliestri/aura-theme",
    lazy = true,
    priority = 1000,
  },
  {
    "nyoom-engineering/oxocarbon.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "steve-lohmeyer/mars.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "artanikin/vim-synthwave84",
    lazy = true,
    priority = 1000,
  },
  {
    "maxmx03/fluoromachine.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "vague-theme/vague.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "rafamadriz/neon",
    lazy = true,
    priority = 1000,
  },
  {
    "askfiy/visual_studio_code",
    lazy = true,
    priority = 1000,
  },
  {
    "nvimdev/zephyr-nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "rockerBOO/boo-colorscheme-nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "jim-at-jibba/ariake.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "Th3Whit3Wolf/onebuddy",
    dependencies = { "tjdevries/colorbuddy.nvim" },
    lazy = true,
    priority = 1000,
  },
  {
    "aktersnurra/no-clown-fiesta.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "Th3Whit3Wolf/space-nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "ray-x/aurora",
    lazy = true,
    priority = 1000,
  },
  {
    "ray-x/starry.nvim",
    opts = {},
    lazy = true,
    priority = 1000,
  },
  {
    "FrenzyExists/aquarium-vim",
    lazy = true,
    priority = 1000,
  },
  {
    "Everblush/nvim",
    name = "everblush-nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "adisen99/apprentice.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "nyngwang/nvimgelion",
    lazy = true,
    priority = 1000,
  },
  {
    "cryptomilk/nightcity.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "morhetz/gruvbox",
    lazy = true,
    priority = 1000,
  },
  {
    "joshdick/onedark.vim",
    lazy = true,
    priority = 1000,
  },
  {
    "altercation/vim-colors-solarized",
    lazy = true,
    priority = 1000,
  },
  {
    "NLKNguyen/papercolor-theme",
    lazy = true,
    priority = 1000,
  },
  {
    "arcticicestudio/nord-vim",
    lazy = true,
    priority = 1000,
  },
  {
    "nanotech/jellybeans.vim",
    lazy = true,
    priority = 1000,
  },
  {
    "sickill/vim-monokai",
    lazy = true,
    priority = 1000,
  },
  {
    "srcery-colors/srcery-vim",
    lazy = true,
    priority = 1000,
  },
  {
    "rakr/vim-one",
    lazy = true,
    priority = 1000,
  },
  {
    "jacoborus/tender.vim",
    lazy = true,
    priority = 1000,
  },
  {
    "Shatur/neovim-ayu",
    lazy = true,
    priority = 1000,
  },
  {
    "tiagovla/tokyodark.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "cpea2506/one_monokai.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "Mofiqul/adwaita.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "NTBBloodbath/doom-one.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "Tsuzat/NeoSolarized.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "svrana/neosolarized.nvim",
    dependencies = { "tjdevries/colorbuddy.nvim" },
    lazy = true,
    priority = 1000,
  },
  {
    "ishan9299/nvim-solarized-lua",
    lazy = true,
    priority = 1000,
  },
  {
    "Yazeed1s/oh-lucy.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "kvrohit/rasmus.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "ofirgall/ofirkai.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "kdheepak/monochrome.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "rockyzhang24/arctic.nvim",
    lazy = true,
    priority = 1000,
  },
  { "yorik1984/newpaper.nvim", lazy = true, priority = 1000 },
  {
    "Verf/deepwhite.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "judaew/ronny.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "oxfist/night-owl.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "miikanissi/modus-themes.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "HoNamDuong/hybrid.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "samharju/synthweave.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "loganswartz/sunburn.nvim",
    dependencies = { "loganswartz/polychrome.nvim" },
    lazy = true,
    priority = 1000,
  },
  {
    "0xstepit/flow.nvim",
    opts = {},
    lazy = true,
    priority = 1000,
  },
  {
    "samharju/serene.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "killitar/obscure.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "bakageddy/alduin.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "diegoulloao/neofusion.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "ayu-theme/ayu-vim",
    lazy = true,
    priority = 1000,
  },
  {
    "ntk148v/slack.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "pmouraguedes/neodarcula.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "jpwol/thorn.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "calind/selenized.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "pebeto/dookie.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "dark-orchid/neovim",
    name = "dark-orchid",
    lazy = true,
    priority = 1000,
    config = function()
      require("dark-orchid").setup()
    end,
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

--  ______   __       ______
-- /_____/\ /_/\     /_____/\
-- \:::_ \ \\:\ \    \:::_ \ \
--  \:\ \ \ \\:\ \    \:\ \ \ \
--   \:\ \ \ \\:\ \____\:\ \ \ \
--    \:\_\ \ \\:\/___/\\:\/.:| |
--  ___\_____\/_\_____\/ \____/_/  ______    _______   ______
-- /________/\/_____/\ /_______/\ /_____/\ /_______/\ /_____/\
-- \__.::.__\/\:::_ \ \\::: _  \ \\:::_ \ \\::: _  \ \\:::_ \ \
--   /_\::\ \  \:\ \ \ \\::(_)  \/_\:\ \ \ \\::(_)  \/_\:\ \ \ \
--   \:.\::\ \  \:\ \ \ \\::  _  \ \\:\ \ \ \\::  _  \ \\:\ \ \ \
--    \: \  \ \  \:\_\ \ \\::(_)  \ \\:\_\ \ \\::(_)  \ \\:\_\ \ \
--     \_____\/   \_____\/ \_______\/ \_____\/ \_______\/ \_____\/
--
