--[[
Top 100+ Themes for nvim on Omarchy
Author: OldJobobo (https://github.com/OldJobobo)
]]

local DEFAULT_SPEC = {
  lazy = true,
  priority = 1000,
}

local themes = {
  -- Load all theme plugins but don't apply them
  -- This ensures all colorschemes are available for hot-reloading
  {
    "ribru17/bamboo.nvim",
    opts = {},
  },
  {
    "OldJobobo/retro-82.nvim",
    name = "retro-82",
  },
  {
    "OldJobobo/biscuit-nvim",
    name = "biscuit",
  },
  {
    "Mofiqul/dracula.nvim",
  },
  {
    "dracula/vim",
    name = "dracula-vim",
  },
  {
    "bjarneo/ash.nvim",
  },
  {
    "bjarneo/vantablack.nvim",
  },
  --
  {
    "bjarneo/aether.nvim",
  },
  {
    "bjarneo/ethereal.nvim",
  },
  {
    "bjarneo/hackerman.nvim",
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
  },
  {
    "sainnhe/everforest",
  },
  {
    "sainnhe/edge",
  },
  {
    "sainnhe/gruvbox-material",
  },
  {
    "sainnhe/sonokai",
  },
  {
    "neanias/everforest-nvim",
  },
  {
    "kepano/flexoki-neovim",
  },
  {
    "ellisonleao/gruvbox.nvim",
  },
  {
    "luisiacc/gruvbox-baby",
  },
  {
    "EdenEast/nightfox.nvim",
  },
  {
    "bluz71/vim-moonfly-colors",
  },
  {
    "bluz71/vim-nightfly-colors",
  },
  {
    "projekt0n/github-nvim-theme",
  },
  {
    "rebelot/kanagawa.nvim",
  },
  {
    "scottmckendry/cyberdream.nvim",
  },
  {
    "marko-cerovac/material.nvim",
  },
  {
    "mhartington/oceanic-next",
  },
  {
    "olimorris/onedarkpro.nvim",
  },
  {
    "tomasiser/vim-code-dark",
  },
  {
    "AlexvZyl/nordic.nvim",
  },
  {
    "tahayvr/matteblack.nvim",
  },
  {
    "gthelding/monokai-pro.nvim",
    name = "monokai-pro-gthelding",
    config = function()
      require("monokai-pro").setup()
    end,
  },
  {
    "shaunsingh/nord.nvim",
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
  },
  {
    "folke/tokyonight.nvim",
  },
  {
    "Mofiqul/vscode.nvim",
  },
  {
    "savq/melange-nvim",
  },
  {
    "fenetikm/falcon",
  },
  {
    "embark-theme/vim",
    name = "embark-vim",
  },
  {
    "rmehri01/onenord.nvim",
  },
  {
    "everviolet/nvim",
  },
  {
    "slugbyte/lackluster.nvim",
  },
  {
    "ramojus/mellifluous.nvim",
  },
  {
    "uloco/bluloco.nvim",
  },
  {
    "mellow-theme/mellow.nvim",
  },
  {
    "zenbones-theme/zenbones.nvim",
  },
  {
    "craftzdog/solarized-osaka.nvim",
  },
  {
    "navarasu/onedark.nvim",
  },
  {
    "eldritch-theme/eldritch.nvim",
  },
  {
    "baliestri/aura-theme",
  },
  {
    "nyoom-engineering/oxocarbon.nvim",
  },
  {
    "steve-lohmeyer/mars.nvim",
  },
  {
    "artanikin/vim-synthwave84",
  },
  {
    "maxmx03/fluoromachine.nvim",
  },
  {
    "vague-theme/vague.nvim",
  },
  {
    "rafamadriz/neon",
  },
  {
    "askfiy/visual_studio_code",
  },
  {
    "nvimdev/zephyr-nvim",
  },
  {
    "rockerBOO/boo-colorscheme-nvim",
  },
  {
    "jim-at-jibba/ariake.nvim",
  },
  {
    "Th3Whit3Wolf/onebuddy",
    dependencies = { "tjdevries/colorbuddy.nvim" },
  },
  {
    "aktersnurra/no-clown-fiesta.nvim",
  },
  {
    "Th3Whit3Wolf/space-nvim",
  },
  {
    "ray-x/aurora",
  },
  {
    "ray-x/starry.nvim",
    opts = {},
  },
  {
    "FrenzyExists/aquarium-vim",
  },
  {
    "Everblush/nvim",
    name = "everblush-nvim",
  },
  {
    "adisen99/apprentice.nvim",
  },
  {
    "nyngwang/nvimgelion",
  },
  {
    "cryptomilk/nightcity.nvim",
  },
  {
    "morhetz/gruvbox",
  },
  {
    "joshdick/onedark.vim",
  },
  {
    "altercation/vim-colors-solarized",
  },
  {
    "NLKNguyen/papercolor-theme",
  },
  {
    "arcticicestudio/nord-vim",
  },
  {
    "nanotech/jellybeans.vim",
  },
  {
    "sickill/vim-monokai",
  },
  {
    "srcery-colors/srcery-vim",
  },
  {
    "rakr/vim-one",
  },
  {
    "jacoborus/tender.vim",
  },
  {
    "Shatur/neovim-ayu",
  },
  {
    "tiagovla/tokyodark.nvim",
  },
  {
    "cpea2506/one_monokai.nvim",
  },
  {
    "Mofiqul/adwaita.nvim",
  },
  {
    "NTBBloodbath/doom-one.nvim",
  },
  {
    "Tsuzat/NeoSolarized.nvim",
  },
  {
    "svrana/neosolarized.nvim",
    dependencies = { "tjdevries/colorbuddy.nvim" },
  },
  {
    "ishan9299/nvim-solarized-lua",
  },
  {
    "Yazeed1s/oh-lucy.nvim",
  },
  {
    "kvrohit/rasmus.nvim",
  },
  {
    "ofirgall/ofirkai.nvim",
  },
  {
    "kdheepak/monochrome.nvim",
  },
  {
    "rockyzhang24/arctic.nvim",
  },
  { "yorik1984/newpaper.nvim" },
  {
    "Verf/deepwhite.nvim",
  },
  {
    "judaew/ronny.nvim",
  },
  {
    "oxfist/night-owl.nvim",
  },
  {
    "miikanissi/modus-themes.nvim",
  },
  {
    "HoNamDuong/hybrid.nvim",
  },
  {
    "samharju/synthweave.nvim",
  },
  {
    "loganswartz/sunburn.nvim",
    dependencies = { "loganswartz/polychrome.nvim" },
  },
  {
    "0xstepit/flow.nvim",
    opts = {},
  },
  {
    "samharju/serene.nvim",
  },
  {
    "killitar/obscure.nvim",
  },
  {
    "bakageddy/alduin.nvim",
  },
  {
    "diegoulloao/neofusion.nvim",
  },
  {
    "ayu-theme/ayu-vim",
  },
  {
    "ntk148v/slack.nvim",
  },
  {
    "pmouraguedes/neodarcula.nvim",
  },
  {
    "jpwol/thorn.nvim",
  },
  {
    "calind/selenized.nvim",
  },
  {
    "pebeto/dookie.nvim",
  },
  {
    "dark-orchid/neovim",
    name = "dark-orchid",
    config = function()
      require("dark-orchid").setup()
    end,
  },
  {
    "OldJobobo/waffle-cat",
    name = "waffle-cat",
  },
  {
    "xero/miasma.nvim",
  },
  {
    "xero/evangelion.nvim",
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

for _, spec in ipairs(themes) do
  for key, value in pairs(DEFAULT_SPEC) do
    if spec[key] == nil then
      spec[key] = value
    end
  end
end

return themes

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
