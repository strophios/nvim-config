return {
	{
		"quarto-dev/quarto-nvim",
		opts = {
			lspFeatures = {
				enabled = true,
				chunks = "curly",
			},
			codeRunner = {
				enabled = true,
				default_method = "iron",
			},
		},
		dependencies = {
			-- for language features in code cells
			"jmbuhr/otter.nvim",
		},
	},
	{ -- preview equations
		"jbyuki/nabla.nvim",
		keys = {
			{ "<leader>m", ":lua require('nabla').popup()<cr>", desc = "preview [m]ath equation" },
		},
	},
}
