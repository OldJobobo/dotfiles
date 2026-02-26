return {
	{
		name = "theme-hotreload",
		dir = vim.fn.stdpath("config"),
		lazy = false,
		priority = 1000,
		config = function()
			local uv = vim.uv
			local transparency_file = vim.fn.stdpath("config") .. "/plugin/after/transparency.lua"
			local omarchy_current_dir = vim.fn.expand("~/.config/omarchy/current")
			local omarchy_theme_dir = vim.fn.expand("~/.config/omarchy/current/theme")
			local omarchy_theme_file = vim.fn.expand("~/.config/omarchy/current/theme/neovim.lua")
			local omarchy_theme_name_file = vim.fn.expand("~/.config/omarchy/current/theme.name")
			local fs_watchers = {}
			local reload_timer = nil
			local poll_timer = nil
			local last_seen_theme_name = nil

			local function apply_theme_from_current_config()
				package.loaded["plugins.theme"] = nil
				local ok, theme_spec = pcall(require, "plugins.theme")
				if not ok or type(theme_spec) ~= "table" then
					return false
				end

				local colorscheme = nil
				for _, spec in ipairs(theme_spec) do
					if type(spec) == "table" and spec[1] and spec[1] ~= "LazyVim/LazyVim" then
						local plugin_name = spec.name or spec[1]
						pcall(require("lazy").load, { plugins = { plugin_name } })
					end
					if
						type(spec) == "table"
						and spec[1] == "LazyVim/LazyVim"
						and type(spec.opts) == "table"
						and type(spec.opts.colorscheme) == "string"
					then
						colorscheme = spec.opts.colorscheme
					end
				end

				if not colorscheme then
					return false
				end

				pcall(require("lazy.core.loader").colorscheme, colorscheme)
				local applied = pcall(vim.cmd.colorscheme, colorscheme)
				if not applied then
					return false
				end

				vim.cmd("redraw!")

				if vim.fn.filereadable(transparency_file) == 1 then
					pcall(vim.cmd.source, transparency_file)
				end
				vim.api.nvim_exec_autocmds("ColorScheme", { modeline = false })
				vim.cmd("redraw!")
				return true
			end

			local function schedule_theme_reload()
				if reload_timer then
					reload_timer:stop()
					reload_timer:close()
					reload_timer = nil
				end

				reload_timer = uv.new_timer()
				if not reload_timer then
					return
				end

				reload_timer:start(
					120,
					0,
					vim.schedule_wrap(function()
						if reload_timer then
							reload_timer:stop()
							reload_timer:close()
							reload_timer = nil
						end
						local ok = apply_theme_from_current_config()
						if not ok then
							vim.api.nvim_exec_autocmds("User", { pattern = "LazyReload", modeline = false })
						end
					end)
				)
			end

			local function read_theme_name()
				local ok, lines = pcall(vim.fn.readfile, omarchy_theme_name_file)
				if not ok or not lines or not lines[1] then
					return nil
				end
				local name = vim.trim(lines[1])
				if name == "" then
					return nil
				end
				return name
			end

			local function detect_theme_change()
				local current_theme_name = read_theme_name()
				if current_theme_name and current_theme_name ~= last_seen_theme_name then
					last_seen_theme_name = current_theme_name
					schedule_theme_reload()
				end
			end

			local function watch_path(path)
				if not uv.fs_stat(path) then
					return
				end

				local watcher = uv.new_fs_event()
				if not watcher then
					return
				end

				local ok = watcher:start(
					path,
					{},
					vim.schedule_wrap(function()
						schedule_theme_reload()
					end)
				)

				if ok then
					table.insert(fs_watchers, watcher)
					return
				end

				watcher:stop()
				watcher:close()
			end

			vim.api.nvim_create_autocmd("User", {
				pattern = "LazyReload",
				callback = function()
					-- Unload the theme module
					package.loaded["plugins.theme"] = nil

					vim.schedule(function()
						local ok, theme_spec = pcall(require, "plugins.theme")
						if not ok then
							return
						end

						-- Find the theme plugin and unload it
						local theme_plugin_name = nil
						for _, spec in ipairs(theme_spec) do
							if spec[1] and spec[1] ~= "LazyVim/LazyVim" then
								theme_plugin_name = spec.name or spec[1]
								break
							end
						end

						-- Clear all highlight groups before applying new theme
						vim.cmd("highlight clear")
						if vim.fn.exists("syntax_on") then
							vim.cmd("syntax reset")
						end

						-- Reset background to default so colorscheme can set it properly (light themes will set to light)
						vim.o.background = "dark"

						-- Unload theme plugin modules to force full reload
						if theme_plugin_name then
							local plugin = require("lazy.core.config").plugins[theme_plugin_name]
							if plugin then
								-- Unload all lua modules from the plugin directory
								local plugin_dir = plugin.dir .. "/lua"
								require("lazy.core.util").walkmods(plugin_dir, function(modname)
									package.loaded[modname] = nil
									package.preload[modname] = nil
								end)
							end
						end

						-- Find and apply the new colorscheme
						for _, spec in ipairs(theme_spec) do
							if spec[1] == "LazyVim/LazyVim" and spec.opts and spec.opts.colorscheme then
								local colorscheme = spec.opts.colorscheme

								-- Load the colorscheme plugin
								require("lazy.core.loader").colorscheme(colorscheme)

								vim.defer_fn(function()
									-- Apply the colorscheme (it will set background itself)
									pcall(vim.cmd.colorscheme, colorscheme)

									-- Force redraw to update all UI elements
									vim.cmd("redraw!")

									-- Reload transparency settings
									if vim.fn.filereadable(transparency_file) == 1 then
										vim.defer_fn(function()
											vim.cmd.source(transparency_file)

											-- Trigger UI updates for various plugins
											vim.api.nvim_exec_autocmds("ColorScheme", { modeline = false })
											vim.api.nvim_exec_autocmds("VimEnter", { modeline = false })

											-- Final redraw
											vim.cmd("redraw!")
										end, 5)
									end
								end, 5)

								break
							end
						end
					end)
				end,
			})

			watch_path(omarchy_theme_name_file)
			watch_path(omarchy_theme_file)
			watch_path(omarchy_current_dir)
			watch_path(omarchy_theme_dir)
			last_seen_theme_name = read_theme_name()

			-- Fallback for atomic directory swaps that can evade fs watchers.
			poll_timer = uv.new_timer()
			if poll_timer then
				poll_timer:start(
					1000,
					1000,
					vim.schedule_wrap(function()
						detect_theme_change()
					end)
				)
			end

			vim.api.nvim_create_autocmd({ "FocusGained", "VimResume", "BufEnter" }, {
				callback = function()
					detect_theme_change()
				end,
			})

			vim.api.nvim_create_autocmd("VimLeavePre", {
				callback = function()
					if reload_timer then
						reload_timer:stop()
						reload_timer:close()
						reload_timer = nil
					end
					if poll_timer then
						poll_timer:stop()
						poll_timer:close()
						poll_timer = nil
					end
					for _, watcher in ipairs(fs_watchers) do
						watcher:stop()
						watcher:close()
					end
				end,
			})
		end,
	},
}
