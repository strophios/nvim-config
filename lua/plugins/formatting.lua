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
					rhs = "<cmd>Checkmate check<CR>",
					desc = "Set todo item as checked (done)",
					modes = { "n", "v" },
				},
				["<leader>tu"] = {
					rhs = "<cmd>Checkmate uncheck<CR>",
					desc = "Set todo item as unchecked (not done)",
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
				["<leader>t-"] = {
					rhs = function()
						require("checkmate").toggle("dropped")
					end,
					desc = "Set todo item as dropped",
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
				due = {
					style = { fg = "#ffb86c", bold = true },
				},
				plan = {
					style = { fg = "#ffb86c" },
				},
				defer = {
					style = { fg = "#9fd6d5" },
				},
				dropped = {
					style = { bold = true },
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
