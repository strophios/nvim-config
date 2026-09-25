local function current_fold_range()
	local lnum = vim.fn.line(".")
	if vim.fn.foldclosed(lnum) ~= -1 then
		return vim.fn.foldclosed(lnum), vim.fn.foldclosedend(lnum)
	end
	if vim.fn.foldlevel(lnum) > 0 then
		local view = vim.fn.winsaveview()
		local s, e
		local ok = pcall(function()
			vim.cmd("normal! zc")
			s, e = vim.fn.foldclosed(lnum), vim.fn.foldclosedend(lnum)
			vim.cmd("normal! zo")
		end)
		vim.fn.winrestview(view)
		if not ok then
			vim.notify("not inside a fold", vim.log.levels.INFO)
			return nil, nil
		end
		return s, e
	end
	vim.notify("not inside a fold", vim.log.levels.INFO)
	return nil, nil
end

local function fold_done(s, e, opts)
	opts = opts or {}
	if opts.open_first then
		vim.cmd(string.format("%d,%dfoldopen!", s, e))
	end
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	for lnum = s, e do
		if lnum ~= opts.root then
			local line = lines[lnum]
			local indent, mark = line:match("^(%s*)[-*+] %[([xX-])%] ")
			local nxt = lines[lnum + 1]
			if mark and nxt and #nxt:match("^%s*") > #indent and nxt:match("%S") then
				if vim.fn.foldclosed(lnum) == -1 then
					pcall(vim.cmd, string.format("%dfoldclose", lnum))
				end
			end
		end
	end
end
return {
	{ -- Autoformat
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = "",
				desc = "[f]ormat buffer",
			},
		},
		opts = {
			notify_on_error = false,
			format_on_save = function(bufnr)
				-- Disable "format_on_save lsp_fallback" for languages that don't
				-- have a well standardized coding style. You can add additional
				-- languages here or re-enable it for the disabled ones.
				local disable_filetypes = { c = true, cpp = true }
				if disable_filetypes[vim.bo[bufnr].filetype] then
					return nil
				else
					return {
						timeout_ms = 500,
						lsp_format = "fallback",
					}
				end
			end,
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "ruff_format", lsp_format = "fallback" },
				json = { "jq" },
				-- Conform can also run multiple formatters sequentially
				-- python = { "isort", "black" },
				--
				-- You can use 'stop_after_first' to run the first available formatter from the list
				-- javascript = { "prettierd", "prettier", stop_after_first = true },
			},
		},
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" }, -- if you use the mini.nvim suite
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {
			completions = { lsp = { enabled = true } },
			latex = { enabled = false },
			checkbox = {
				custom = {
					todo = { raw = nil },
					dropped = { raw = "[-]", rendered = "✗", scope_highlight = "@markup.strikethrough" },
					waiting = { raw = "[>]", rendered = "" },
					needs_decision = { raw = "[?]", rendered = "" },
				},
			},
		},
	},
	{
		"folke/snacks.nvim",
		---@type snacks.Config
		opts = {
			image = {
				doc = {
					float = true,
					max_width = 160, -- 2x the default
					max_height = 40, -- the default
				},
				math = {
					enabled = true,
					latex = {
						font_size = "large",
					},
				},
			},
		},
	},
	{
		"bngarren/checkmate.nvim",
		ft = "markdown", -- Lazy loads for Markdown files matching patterns in 'files'
		opts = {
			files = { "**/tasks/projects/*.md", "**/tasks/*.md" },
			keys = {
				["<leader>tc"] = {
					rhs = function()
						local cm = require("checkmate")
						cm.check()
						cm.remove_metadata("dropped")
						local todo = cm.get_todo()
						if todo then
							local tag = todo.get_metadata("done")
							if not tag then
								cm.add_metadata("done")
							end
						end
					end,
					desc = "Check todo and stamp @done(today)",
					modes = { "n", "v" },
				},
				["<leader>tu"] = {
					rhs = function()
						local cm = require("checkmate")
						cm.uncheck()
						cm.remove_metadata("done")
						cm.remove_metadata("dropped")
					end,
					desc = "Uncheck todo and remove stamps",
					modes = { "n", "v" },
				},
				["<leader>t-"] = {
					rhs = function()
						local cm = require("checkmate")
						cm.toggle("dropped")
						cm.remove_metadata("done")
						local todo = cm.get_todo()
						if todo then
							local tag = todo.get_metadata("dropped")
							if not tag then
								cm.add_metadata("dropped")
							end
						end
					end,
					desc = "Drop todo and stamp @dropped(today)",
					modes = { "n", "v" },
				},
				-- Custom states: `toggle(state)` is a "set" (no-op if already in that state).
				-- Key mnemonics are the markers themselves: [>] [-] [?]
				["<leader>t>"] = {
					rhs = function()
						require("checkmate").toggle("waiting")
					end,
					desc = "Set todo item as waiting",
					modes = { "n", "v" },
				},
				["<leader>t?"] = {
					rhs = function()
						require("checkmate").toggle("needs_decision")
					end,
					desc = "Set todo item as needs decision",
					modes = { "n", "v" },
				},
				["<leader>tn"] = {
					rhs = "<cmd>Checkmate create<CR>",
					desc = "Create todo item",
					modes = { "n", "v" },
				},
				["<leader>t]"] = {
					rhs = "<cmd>Checkmate cycle_next<CR>",
					desc = "Cycle todo item(s) to the next state",
					modes = { "n", "v" },
				},
				["<leader>t["] = {
					rhs = "<cmd>Checkmate cycle_previous<CR>",
					desc = "Cycle todo item(s) to the previous state",
					modes = { "n", "v" },
				},
				["<leader>tzR"] = {
					rhs = function()
						if vim.wo.foldmethod ~= "expr" then
							return
						end
						fold_done(1, vim.fn.line("$"), { open_first = true })
					end,
					desc = "Close done subtrees, buffer (open first)",
					modes = { "n" },
				},
				["<leader>tzr"] = {
					rhs = function()
						if vim.wo.foldmethod ~= "expr" then
							return
						end
						local s, e = current_fold_range()
						if not s then
							return
						end
						fold_done(s, e, { open_first = true, root = s })
					end,
					desc = "Close done subtrees, current fold (open first)",
					modes = { "n" },
				},
				["<leader>tzC"] = {
					rhs = function()
						if vim.wo.foldmethod ~= "expr" then
							return
						end
						fold_done(1, vim.fn.line("$"))
					end,
					desc = "Close done subtrees, buffer",
					modes = { "n" },
				},
				["<leader>tzc"] = {
					rhs = function()
						if vim.wo.foldmethod ~= "expr" then
							return
						end
						local s, e = current_fold_range()
						if not s then
							return
						end
						fold_done(s, e, { root = s })
					end,
					desc = "Close done subtrees, current fold",
					modes = { "n" },
				},
			},
			todo_states = {
				unchecked = {
					marker = "[ ]",
				},
				checked = {
					marker = "[x]",
				},
				waiting = {
					marker = "[>]",
					markdown = ">",
					type = "inactive",
				},
				needs_decision = {
					marker = "[?]",
					markdown = "?",
					type = "incomplete",
				},
				dropped = {
					marker = "[-]",
					markdown = "-",
					type = "complete",
				},
			},
			style = {
				CheckmateWaitingMarker = { fg = "#9fd6d5" },
				-- CheckmateWaitingMainContent = {},
				CheckmateNeedsDecisionMarker = { fg = "#8060a0" },
				-- CheckmateNeedsDecisionMainContent = { fg = "#8060a0" },
				CheckmateDroppedMarker = { fg = "#ffb86c" },
				CheckmateDroppedMainContent = { strikethrough = true },
			},
			metadata = {
				done = {
					get_value = function()
						return os.date("%Y-%m-%d")
					end,
				},
				dropped = {
					get_value = function()
						return os.date("%Y-%m-%d")
					end,
					style = { bold = true },
				},
				due = {
					style = { fg = "#ffb86c", bold = true },
				},
				plan = {
					style = { fg = "#ffb86c" },
				},
				defer = {
					style = { fg = "#9fd6d5" },
				},
				waiting = {
					style = { fg = "#8be9fd" },
				},
				est = {
					style = { fg = "#9fd6d5" },
				},
				lead = {
					style = { fg = "#ffb86c" },
				},
			},
		},
	},
}
-- vim: ts=2 sts=2 sw=2 et
