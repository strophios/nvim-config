-- Set leader key to <space>
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Speed up development by creating keymaps for sourcing the current file
-- or current (normal mode) or selected (visual mode) lines
vim.keymap.set("n", "<leader><leader>x", "<cmd>source %<CR>")
vim.keymap.set("n", "<leader>x", ":.lua<CR>")
vim.keymap.set("v", "<leader>x", ":lua<CR>")

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Setting Options ]]
require("options")

-- [[ Basic Keymaps ]]
require("keymaps")

-- [[ Lazy Plugin Manager + Plugins ]]
require("lazy-plugins")

-- Autocommand to make the telescope preview window line wrap
vim.api.nvim_create_autocmd("User", {
	pattern = "TelescopePreviewerLoaded",
	callback = function()
		vim.wo.wrap = true
	end,
})
