return {
	{
		"windwp/nvim-autopairs", -- Autopair quote, parens, etc.
		event = "InsertEnter",
		config = function()
			local npairs = require("nvim-autopairs")
			local Rule = require("nvim-autopairs.rule")
			local cond = require("nvim-autopairs.conds")

			npairs.setup()
			npairs.add_rule(Rule("<!--", "-->", { "quarto" }):with_cr(cond.none()))
		end,
	},
	{
		"NMAC427/guess-indent.nvim", -- Detect tabstop and shiftwidth automatically
		opts = {
			override_editorconfig = true,
			on_tab_options = { -- A table of vim options when tabs are detected
				["expandtab"] = true, -- Not totally sure if we want this, but using for now
			},
		},
	},
	{ -- "indent guides with scope on every keystroke (0.1-1ms per render)"
		"saghen/blink.indent",
		--- @module 'blink.indent'
		--- @type blink.indent.Config
		-- opts = {},
	},
	{ -- Collection of various small independent plugins/modules
		"echasnovski/mini.nvim",
		config = function()
			-- Better Around/Inside textobjects
			-- Examples:
			--  - va)  - [V]isually select [A]round [)]paren
			--  - yinq - [Y]ank [I]nside [N]ext [Q]uote
			--  - ci'  - [C]hange [I]nside [']quote
			require("mini.ai").setup({ n_lines = 500 })

			-- Add/delete/replace surroundings (brackets, quotes, etc.)
			-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
			-- - sd'   - [S]urround [D]elete [']quotes
			-- - sr)'  - [S]urround [R]eplace [)] [']
			require("mini.surround").setup()

			-- Simple and easy statusline.
			--  You could remove this setup call if you don't like it,
			--  and try some other statusline plugin
			local statusline = require("mini.statusline")
			-- set use_icons to true if you have a Nerd Font
			statusline.setup({ use_icons = vim.g.have_nerd_font })

			-- You can configure sections in the statusline by overriding their
			-- default behavior. For example, here we set the section for
			-- cursor location to LINE:COLUMN
			---@diagnostic disable-next-line: duplicate-set-field
			statusline.section_location = function()
				return "%2l:%-2v"
			end
			-- ... and there is more!
			--  Check out: https://github.com/echasnovski/mini.nvim
		end,
	},
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},
	{ -- NOTE:
		"folke/ts-comments.nvim",
		enabled = false,
		event = "VeryLazy",
		opts = {
			lang = {
				quarto = "<!-- %s -->",
				rmarkdown = "<!-- %s -->",
			},
		},
	},
}
