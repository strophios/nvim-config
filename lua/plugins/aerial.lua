return {
	{ -- show tree of symbols in the current file
		"stevearc/aerial.nvim",
		keys = {
			{ "<leader>do", "<cmd>AerialToggle<CR>", desc = "Toggle [d]ocument [o]utline (aerial)" },
			{ "<leader>dn", "<cmd>AerialNavToggle<CR>", desc = "Toggle [d]ocument [n]avigator (aerial)" },
		},
		opts = {
			layout = { min_width = 25 },
		},
	},
}
