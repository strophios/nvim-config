-- NOTE: Plugins can also be configured to run Lua code when they are loaded.
--
-- This is often very useful to both group configuration, as well as handle
-- lazy loading plugins that don't need to be loaded immediately at startup.
--
-- For example, in the following configuration, we use:
--  event = 'VimEnter'
--
-- which loads which-key before all the UI elements are loaded. Events can be
-- normal autocommands events (`:help autocmd-events`).
--
-- Then, because we use the `opts` key (recommended), the configuration runs
-- after the plugin has been loaded as `require(MODULE).setup(opts)`.

return {
	{ -- Useful plugin to show you pending keybinds.
		"folke/which-key.nvim",
		event = "VimEnter", -- Sets the loading event to 'VimEnter'
		opts = {
			-- delay between pressing a key and opening which-key (milliseconds)
			-- this setting is independent of vim.o.timeoutlen
			delay = 0,
			icons = {
				-- set icon mappings to true if you have a Nerd Font
				mappings = vim.g.have_nerd_font,
				-- If you are using a Nerd Font: set icons.keys to an empty table which will use the
				-- default which-key.nvim defined Nerd Font icons, otherwise define a string table
				keys = {},
			},

			-- Document existing key chains
			spec = {
				{ "<leader>b", group = "[b]uffer" },
				{ "<leader>d", group = "[d]ocument outline" },
				{ "<leader>r", group = "[r]EPL" },
				{ "<leader>s", group = "[s]earch" },
				{ "<leader>t", group = "[t]oggle" },
				{ "<leader>w", group = "[w]orkspaces" },
				-- Documenting LSP grouping, which is a little bit a pain, since I have the top level group, but also subgroups
				{ "<leader>l", group = "[l]sp" },
				{ "<leader>lg", group = "[g]o to" },
				{ "<leader>ls", group = "show [s]ymbols" },
				{ "<leader>lc", group = "show [c]alls" },

				{ "<leader>g", ":lua Snacks.lazygit.open()<cr>", desc = "open lazy[g]it" },

				-- { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } }, -- NOTE: I believe this is for working with gitsigns, which I'm not using to this degree

				-- -- Adding Quarto keymaps and groups -- NOTE: Temporarily commenting out Quarto shortcuts
				-- { '<leader>q', group = '[Q]uarto' },
				-- { '<leader>qa', ':QuartoActivate<cr>', desc = '[a]ctivate' },
				-- { '<leader>qe', require('custom.plugins.otter').export, desc = '[e]xport' },
				-- { '<leader>qh', ':QuartoHelp ', desc = '[h]elp' },
				-- { '<leader>qp', ":lua require'quarto'.quartoPreview()<cr>", desc = '[p]review' },
				-- { '<leader>qu', ":lua require'quarto'.quartoUpdatePreview()<cr>", desc = '[u]pdate preview' },
				-- { '<leader>qq', ":lua require'quarto'.quartoClosePreview()<cr>", desc = '[q]uiet preview' },
				-- { '<leader>qm', ':lua require"nabla".toggle_virt()<cr>', desc = 'toggle [m]ath equations' },
				-- { '<leader>qo', require('custom.plugins.otter').activate, desc = 'otter (de)[a]ctivate' },
				-- { '<leader>qr', group = '[r]un' }, -- NOTE: May want to change to bring this group into the general [R]EPL group
				--
				-- { '<leader>qrc', ':QuartoSend<cr>', desc = 'run [c]ell' },
				-- { '<leader>qra', ':QuartoSendAll<cr>', desc = 'run [a]ll' },
				-- { '<leader>qrb', ':QuartoSendBelow<cr>', desc = 'run [b]elow' },
				-- { '<leader>qrr', ':QuartoSendAbove<cr>', desc = 'to cu[r]sor' },
			},
		},
	},
}
-- vim: ts=2 sts=2 sw=2 et
