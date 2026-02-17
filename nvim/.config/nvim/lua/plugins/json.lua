return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        jsonls = {
          settings = {
            json = {
              schemas = {
                {
                  fileMatch = {
                    "*/waybar/config",
                    "*/waybar/config.json",
                    "*/waybar/config.jsonc",
                  },
                  url = "https://raw.githubusercontent.com/Magniquick/waybar-config-schema/main/schema.json",
                },
              },
              validate = { enable = true },
            },
          },
        },
      },
    },
  },
}
