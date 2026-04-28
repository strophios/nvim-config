-- Currently copied from https://codeberg.org/pjphd/neovim_config/src/branch/main/lua/plugins/iron.lua
return {
	{
		"Vigemus/iron.nvim",
		config = function()
			local iron = require("iron.core")
			local common = require("iron.fts.common")
			local view = require("iron.view")

			local custom_repl_command = function(width, height)
				-- view.center returns a function which, when called, returns the config for the float to be called
				-- So we create a wrapper for it that calls it, adds to the output, and returns the new config, and we
				-- will return that function to repl_open_cmd
				return function()
					local win_opts = {}
					win_opts.border = "rounded"
					win_opts.title = "REPL" -- ideally, we change this so that it corresponds to the buffer filetype
					win_opts.title_pos = "center"
					return vim.tbl_deep_extend("force", view.center(width, height)(), win_opts)
				end
			end

			iron.setup({
				config = {
					-- Highlights the last sent block with bold
					highlight_last = "IronLastSent",
					-- Whether a repl should be discarded or not
					scratch_repl = true,
					-- Your repl definitions come here
					repl_definition = {
						R = {
							-- Can be a table or a function that
							-- returns a table (see below)
							command = { "radian" }, -- Radian no longer in active dev; could try arf instead?
							format = common.bracketed_paste,
						},
						r = {
							command = { "radian" },
							format = common.bracketed_paste,
						},
						python = {
							command = { "python3" }, -- or { "ipython", "--no-autoindent" }
							format = common.bracketed_paste_python,
							block_dividers = { "# %%", "#%%" },
							env = { PYTHON_BASIC_REPL = "1" }, --this is needed for python3.13 and up.
						},
					},
					-- How the repl window will be displayed
					-- See below for more information
					repl_open_cmd = custom_repl_command("80%", "70%"), -- See above
				},
				-- iron doesn't set keymaps by default anymore.
				-- You can set them here or manually add keymaps to the functions in iron.core
				-- NOTE: no longer using this way of setting keymaps, since I can't figure out how to
				-- get it to play nice with which-key.nvim (that is, I can't set a description different
				-- from the table key, so none of the which-key labels match the style). Now I'm setting
				-- all keymaps separately, below.
				keymaps = {
					-- send_mark = "<localleader>rm",
					-- mark_motion = "<localleader>mc",
					-- mark_visual = "<localleader>mc",
					-- remove_mark = "<localleader>md",
				},
				-- If the highlight is on, you can change how it looks
				-- For the available options, check nvim_set_hl
				highlight = false,
				ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
			})

			-- iron also has a list of commands, see :h iron-commands for all available commands
			vim.keymap.set("n", "<localleader>rr", "<cmd>IronRepl<cr>", { desc = "toggle [r]epl" })
			vim.keymap.set("v", "<c-cr>", function()
				iron.visual_send()
			end, { desc = "<c-cr>visual send" }) -- Not entirely sure why we can't just have iron.visual_send() on its own
			vim.keymap.set("n", "<localleader>rF", function()
				iron.send_file()
			end, { desc = "send [F]ile" })
			vim.keymap.set({ "n", "i" }, "<c-cr>", function()
				iron.send_line()
			end, { desc = "send [l]ine" })
			vim.keymap.set("n", "<localleader>ru", function()
				iron.send_until_cursor()
			end, { desc = "send [u]ntil cursor" })
			vim.keymap.set("n", "<localleader>re", function()
				iron.send(nil, string.char(13))
			end, { desc = "send [e]nter to repl" })
			vim.keymap.set("n", "<localleader>r<space>", function()
				iron.send(nil, string.char(03))
			end, { desc = "[i]nterrupt" })
			vim.keymap.set("n", "<localleader>rq", function()
				iron.close_repl()
			end, { desc = "[q]uit repl" })
			vim.keymap.set("n", "<localleader>rc", function()
				iron.send(nil, string.char(12))
			end, { desc = "[c]lear repl" })

			vim.keymap.set("n", "<localleader>rR", "<cmd>IronRestart<cr>", { desc = "[r]epl [R]estart" })
			vim.keymap.set("n", "<localleader>rf", "<cmd>IronFocus<cr>", { desc = "[r]epl [f]ocus" })
			vim.keymap.set("n", "<localleader>rh", "<cmd>IronHide<cr>", { desc = "[r]epl [h]ide" })
		end,
	},
}
