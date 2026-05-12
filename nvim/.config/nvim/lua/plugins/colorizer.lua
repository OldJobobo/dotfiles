return {
  {
    "NvChad/nvim-colorizer.lua",
    lazy = false,
    config = function()
      local digit_bytes = { 48, 49, 50, 51, 52, 53, 54, 55, 56, 57 }

      local function ensure_attached(bufnr, delay)
        if not vim.api.nvim_buf_is_valid(bufnr) then
          return
        end

        local run = function()
          if not vim.api.nvim_buf_is_valid(bufnr) then
            return
          end

          pcall(require("colorizer").attach_to_buffer, bufnr)
        end

        if delay and delay > 0 then
          vim.defer_fn(run, delay)
        else
          vim.schedule(run)
        end
      end

      local function refresh_all_visible_buffers()
        for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buflisted then
            ensure_attached(bufnr)
            ensure_attached(bufnr, 180)
          end
        end
      end

      local function is_comment_match(ctx)
        local line = ctx.line_nr + 1
        local col = ctx.col
        local ok, captures = pcall(vim.treesitter.get_captures_at_pos, ctx.bufnr, line - 1, col - 1)
        local current = ctx.line:sub(col)

        -- Generic `conf` syntax often misclassifies inline hex values in files
        -- like kitty.conf as comments because they start with `#`.
        if current:match("^#%x%x%x%f[^%x]") or current:match("^#%x%x%x%x%f[^%x]") or current:match("^#%x%x%x%x%x%x%f[^%x]")
          or current:match("^#%x%x%x%x%x%x%x%x%f[^%x]")
        then
          return false
        end

        if ok then
          for _, capture in ipairs(captures) do
            if capture.capture and capture.capture:lower():find("comment", 1, true) then
              return true
            end
          end
        end

        local ids = vim.fn.synstack(line, col)
        if #ids == 0 then
          ids = { vim.fn.synID(line, col, 1) }
        end

        for _, id in ipairs(ids) do
          local raw = vim.fn.synIDattr(id, "name") or ""
          local translated = vim.fn.synIDattr(vim.fn.synIDtrans(id), "name") or ""

          if raw:lower():find("comment", 1, true) or translated:lower():find("comment", 1, true) then
            return true
          end
        end

        return false
      end

      require("colorizer").setup({
        filetypes = { "*" },
        options = {
          parsers = {
            names = { enable = false },
            hex = {
              rgb = true,
              rrggbb = true,
              rrggbbaa = true,
              no_hash = true,
            },
            rgb = { enable = true },
            hsl = { enable = true },
            custom = {
              {
                name = "chromium_rgb_triplet",
                prefix_bytes = digit_bytes,
                parse = function(ctx)
                  local prev = ctx.col > 1 and ctx.line:sub(ctx.col - 1, ctx.col - 1) or ""
                  if prev:match("%d") then
                    return
                  end

                  local r, g, b = ctx.line:sub(ctx.col):match("^(%d%d?%d?),(%d%d?%d?),(%d%d?%d?)")
                  if not r then
                    return
                  end

                  r = tonumber(r)
                  g = tonumber(g)
                  b = tonumber(b)

                  if not r or not g or not b or r > 255 or g > 255 or b > 255 then
                    return
                  end

                  local len = #tostring(r) + #tostring(g) + #tostring(b) + 2
                  local next_char = ctx.line:sub(ctx.col + len, ctx.col + len)
                  if next_char:match("%d") then
                    return
                  end

                  return len, string.format("%02x%02x%02x", r, g, b)
                end,
              },
            },
          },
          display = {
            mode = "background",
          },
          hooks = {
            should_highlight_color = function(_, parser_name, ctx)
              if is_comment_match(ctx) then
                return false
              end

              if parser_name ~= "chromium_rgb_triplet" then
                return true
              end

              local name = vim.api.nvim_buf_get_name(ctx.bufnr)
              return name:match("chromium%.theme$") ~= nil
            end,
          },
        },
      })

      local group = vim.api.nvim_create_augroup("UserColorizerEnsureAttach", { clear = true })

      vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "FileType" }, {
        group = group,
        callback = function(args)
          ensure_attached(args.buf)
          ensure_attached(args.buf, 180)
        end,
      })

      vim.api.nvim_create_autocmd("VimEnter", {
        group = group,
        callback = function()
          refresh_all_visible_buffers()
        end,
      })

      vim.api.nvim_create_autocmd("ColorScheme", {
        group = group,
        callback = function()
          refresh_all_visible_buffers()
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        group = group,
        pattern = "LazyReload",
        callback = function()
          refresh_all_visible_buffers()
        end,
      })
    end,
  },
}
