return {
	-- Some notes on our LSP implementation in this config:
	-- First, and maybe most importantly, we are not using Mason at all; we're handling all
	-- LSP and tooling installs manually at the system level.
	-- Second, we are, however, still using nvim-lspconfig for easy access to intelligent
	-- defaults and facilitating setup. Indeed, we're doing all the setup within the loading
	-- of nvim-lspconfict.
	-- Third...something something to do with otter.nvim and quarto.nvim, but I'm not sure
	-- what yet, cause I don't actually have them working yet.
	-- Finally, this implementation is mostly copied from a combination jmbuhr, vhyrro's
	-- "Understanding Neovim" YouTube series, pjphd, and hendrikmi's config.
	{
		"jmbuhr/otter.nvim",
		dependencies = {
			{
				"neovim/nvim-lspconfig",
				"nvim-treesitter/nvim-treesitter",
			},
		},
		---@type OtterConfig
		opts = {
			buffers = {
				write_to_disk = true,
			},
		},
	},
	{
		-- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
		-- used for completion, annotations and signatures of Neovim apis
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Useful status updates for LSP.
			{ "j-hui/fidget.nvim", opts = {} },

			-- Allows extra capabilities provided by blink.cmp
			"saghen/blink.cmp",
		}, -- Not sure if this is the ideal way to do it, but I think it should work.
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
				-- Create a function that lets us more easily define mappings specific LSP related items.
				-- It sets the mode, buffer and description for us each time.
				callback = function(event)
					-- Testing out having all LSP keymaps gated behind <leader>l
					local map = function(keys, func, desc)
						keys = "<leader>l" .. keys
						vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					-- NOTE: Currently the map function autoprefixes all of these keybinds with <leader>l
					map("gd", vim.lsp.buf.definition, "go to [d]efinition")
					map("gr", vim.lsp.buf.references, "go to [r]eferences")
					map("gt", vim.lsp.buf.type_definition, "go to [t]ype definition")
					map("gm", vim.lsp.buf.implementation, "go to i[m]plementations")
					map("n", vim.lsp.buf.rename, "re[n]ame")
					map("a", vim.lsp.buf.code_action, "code [a]ction")
					map("t", vim.lsp.buf.typehierarchy, "show [t]ype hierarchy")
					map("q", vim.diagnostic.setqflist, "lsp diagnostic [q]uickfix")

					map("sd", vim.lsp.buf.document_symbol, "[d]ocument symbols")
					map("sw", vim.lsp.buf.workspace_symbol, "[w]orkspace symbols")

					-- map("wd", vim.lsp.buf.workspace_diagnostics, "[w]orkspace [d]iagnostics") -- NOTE: This is in the online documentation, but not my local docs; it could be a Neovim .12 thing?

					map("ci", vim.lsp.buf.incoming_calls, "[i]ncoming calls") -- Arguably these could be under "go to..." as well
					map("co", vim.lsp.buf.outgoing_calls, "[o]utgoing calls")

					map("wf", function()
						print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
					end, "[w]orkspace [f]olders")

					-- NOTE: Below are my first try at keymaps, I'm testing an alternate set that works better with which-key groups.
					--
					-- map("gd", vim.lsp.buf.definition, "[g]o to [d]efinition")
					-- map("gr", vim.lsp.buf.references, "[g]o to [r]eferences")
					-- map("gt", vim.lsp.buf.type_definition, "[g]o to [t]ype definition")
					-- map("rn", vim.lsp.buf.rename, "[r]e[n]ame")
					-- map("ca", vim.lsp.buf.code_action, "[c]ode [a]ction")
					-- map("th", vim.lsp.buf.typehierarchy, "show [t]ype [h]ierarchy")
					-- map("qf", vim.diagnostic.setqflist, "lsp diagnostic [q]uickfix")
					--
					-- map("ds", vim.lsp.buf.document_symbol, "[d]ocument [s]ymbols")
					-- map("ws", vim.lsp.buf.workspace_symbol, "[w]orkspace [s]ymbols")
					--
					-- -- map("wd", vim.lsp.buf.workspace_diagnostics, "[w]orkspace [d]iagnostics")
					-- map("ic", vim.lsp.buf.incoming_calls, "[i]ncoming [c]alls")
					-- map("oc", vim.lsp.buf.outgoing_calls, "[o]utgoing [c]alls")
					-- map("im", vim.lsp.buf.implementation, "[im]plementation")
					--
					-- map("wf", function()
					--   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
					-- end, "[w]orkspace [f]olders")
					-- I don't think I need to redefine, e.g., shift-K for show hover info,
					-- or C-s for signature help (not totally sure though)

					-- The following two autocommands are used to highlight references of the
					-- word under your cursor when your cursor rests there for a little while.
					--    See `:help CursorHold` for information about when this is executed
					-- When you move your cursor, the highlights will be cleared (the second autocommand).
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
						local highlight_augroup =
							vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
							end,
						})
					end
				end,
			})

			-- Now the list of servers that we want to enable (and have installed elsewhere)
			local servers = {
				ruff = {},
				ty = {},
				marksman = {},
				r_language_server = {
					cmd = { "R", "--no-echo", "-e", "languageserver::run()" },
					filetypes = { "r" }, -- compared with default, we remove rmarkdown and quarto, which should be handled by otter.nvim
					root_dir = function(bufnr, on_dir)
						on_dir(vim.fs.root(bufnr, ".git") or vim.uv.os_homedir())
					end,
					settings = {
						r = {
							rich_documentation = true, -- Turns out this is the default
						},
					},
				},
				bashls = {}, -- add .zsh? .slurm? as additional `filetypes`?
				clangd = {},
				lua_ls = {
					cmd = { "lua-language-server" },
					filetypes = { "lua" },
					root_markers = {
						".luarc.json",
						".luarc.jsonc",
						".luacheckrc",
						".stylua.toml",
						"stylua.toml",
						"selene.toml",
						"selene.yml",
						".git",
					},
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
							diagnostics = { disable = { "missing-fields", "trailing-space" } },
						},
					},
					-- I'm letting lazydev.nvim handle the task of configuring lua_ls for working on my Neovim config and am thus using a very basic
					-- (mostly) default configuration here. However, there is a more complex one recommended in the nvim-lspconfig docs for the case that
					-- you're primarily using lua for Neovim, so that might be worth trying out at some point or if lazydev doesn't seem to be getting
					-- me what I want.
				},
				ts_ls = {},
				yamlls = {},
			}

			-- Other potential LSPs and tools we may wish to install:
			-- bqls = {}, -- BigQuery SQL
			-- cmake = {}, -- cmake
			-- contextive = {}, -- "Contextive allows you to define terms in a central file and provides auto-completion suggestions and hover panels for these terms wherever they're used".
			-- copilot = {}, -- for GitHub copilot integration
			-- html = {},
			-- jinja_lsp = {}, -- for Jinja SQL templating (I think)
			-- -- maybe want a LaTex LSP?
			-- markdown_oxide = {}, -- "Editor Agnostic PKM: you bring the text editor and we bring the PKM. Inspired by and compatible with Obsidian."
			-- nushell = {}, -- In case I decide to start using nushell
			-- postgres_lsp = {}, -- "A collection of language tools and a Language Server Protocol (LSP) implementation for Postgres, focusing on developer experience and reliable SQL tooling".
			-- gopls = {},
			-- pyright = {},
			-- rust_analyzer = {},

			for server, cfg in pairs(servers) do
				-- For each LSP server (cfg), we merge:
				-- 1. A fresh empty table (to avoid mutating capabilities globally)
				-- 2. Your capabilities object with Neovim + cmp features
				-- 3. Any server-specific cfg.capabilities if defined in `servers`
				-- cfg.capabilities = vim.tbl_deep_extend('force', {}, capabilities, cfg.capabilities or {})
				-- Except we don't need to do anything with capabilities, I don't think. Keeping here as a reminder in case I run into issues.

				vim.lsp.config(server, cfg)
				vim.lsp.enable(server)
			end
		end,
	},
}
