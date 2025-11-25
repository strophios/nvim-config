return {
	{
		"saghen/blink.cmp",
		-- optional: provides snippets for the snippet source
		dependencies = {
			{ "rafamadriz/friendly-snippets" },
			{ "folke/lazydev.nvim" },
			{ "strophios/blink-cmp-pandoc-references", branch = "dev", ft = { "quarto", "markdown", "rmarkdown" } },
			{ "erooke/blink-cmp-latex" },
			{ "xzbdmw/colorful-menu.nvim" },
		},
		event = "VimEnter",
		-- use a release tag to download pre-built binaries
		version = "1.*",
		-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
		-- build = 'cargo build --release',

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			keymap = {
				preset = "none",
				-- Note: this is a combination of the default preset and custom keymaps.
				-- I've noted which maps are custom and left (most) of the default maps
				-- commented out if not being used.
				["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
				["<C-e>"] = { "hide", "fallback" },
				-- ['<C-y>'] = { 'select_and_accept', 'fallback' },
				-- ['<C-p>'] = { 'select_prev', 'fallback_to_mappings' },
				-- ['<C-n>'] = { 'select_next', 'fallback_to_mappings' },

				-- Custom maps for selection, leveraging hjkl intuitions
				["<C-k>"] = { "select_prev" },
				["<C-j>"] = { "select_next" },
				["<C-l>"] = { "snippet_forward", "select_and_accept", "fallback" },
				["<C-h>"] = { "snippet_backward", "select_and_accept", "fallback" },
				["<C-CR>"] = { "select_and_accept", "fallback" }, -- Control-Enter instead of just enter, so we don't get an autocomplete when we want a newline, or vice versa

				["<C-b>"] = { "scroll_documentation_up", "fallback" },
				["<C-f>"] = { "scroll_documentation_down", "fallback" },

				["<Tab>"] = { "snippet_forward", "fallback" },
				["<S-Tab>"] = { "snippet_backward", "fallback" },

				["<C-s>"] = { "show_signature", "hide_signature", "fallback" },
				-- Default preset: C-k; originally I wanted to change this to C-K (note case), but apparently terminal emulators
				-- don't differentiate between C-letter and C-LETTER, irritatingly.
			},

			-- By default, blink copies the behavior of base NeoVim in command mode, including keymaps.
			-- Setting `preset = "inherit"` makes it instead use the same keymaps we defined above.
			-- see here: https://cmp.saghen.dev/modes/cmdline.html
			cmdline = {
				keymap = { preset = "inherit" },
				completion = { menu = { auto_show = true } },
			},

			-- term = { } -- NOTE: May also have different behavior in terminal mode, so I may want to update this later.

			appearance = {
				-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "mono",
			},

			-- (Default) Only show the documentation popup when manually triggered
			completion = {
				documentation = { auto_show = true, auto_show_delay_ms = 500 },
				menu = { -- NOTE: Testing out using colorful-menu.nvim
					draw = {
						-- We don't need label_description now because label and label_description are already
						-- combined together in label by colorful-menu.nvim.
						columns = { { "kind_icon" }, { "label", gap = 1 } },
						components = {
							label = {
								text = function(ctx)
									return require("colorful-menu").blink_components_text(ctx)
								end,
								highlight = function(ctx)
									return require("colorful-menu").blink_components_highlight(ctx)
								end,
							},
						},
					},
				},
			},

			-- Default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			sources = {
				default = { "lsp", "path", "snippets", "lazydev", "latex", "references" }, -- Do I want to add "buffer" as a source?
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						score_offset = 100,
					},
					latex = {
						name = "Latex",
						module = "blink-cmp-latex",
						opts = {
							insert_command = true,
						},
					},
					references = {
						name = "pandoc_references",
						module = "blink-cmp-pandoc-references",
						score_offset = 2,
					},
					-- NOTE: ideally I'd find a way to toggle this as needed, since the snippets are actually pretty cool sometimes
					snippets = {
						enabled = function()
							return not vim.tbl_contains({ "markdown", "quarto", "rmarkdown" }, vim.bo.filetype)
						end,
					},
				},
			},

			-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
			-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
			-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
			--
			-- See the fuzzy documentation for more information
			fuzzy = { implementation = "prefer_rust_with_warning" },

			-- Shows a signature help window while you type arguments for a function
			signature = { enabled = true },
		},
		opts_extend = { "sources.default" },
	},
}
