-- [[ Bootstrap install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
-- `:Lazy` to check the current status of plugins
-- `:Lazy update` to update plugins
require("lazy").setup({
	require("plugins.editing"), -- Set of smaller plugins affecting the typing/editing experience (e.g., mini.nvim, guess-indent)
	require("plugins.workspace-navigation"), -- Plugins related to creating, organizing, and navigating workspaces file, buffer, and workspace
	require("plugins.telescope"), -- Telescope and zotero-telescope (for bibliography construction)
	require("plugins.treesitter"), -- Treesitter
	require("plugins.git"), -- Currently just gitsigns, with a bunch of it commented out cause I don't really use git from within Neovim, but with the option to expand.
	require("plugins.which-key"), -- Keymaps and keymap organization
	require("plugins.lsp"), -- LSP setup. Note that I'm handling the downloads of LSP servers myself, externally (i.e., not using mason).
	require("plugins.completion"), -- blink.cmp
	require("plugins.devdocs"), -- Offline devdocs
	require("plugins.iron"), -- REPLs
	require("plugins.formatting"), -- Autoformatting on save w/ conform
	require("plugins.aerial"), -- Outline creation and (I think) navigation
	require("plugins.quarto"), -- For handling quarto files; also includes nabla.nvim for displaying and previewing math equations.
	require("plugins.notify"), -- Adding nvim-notify to handle notifications. potential alternatives indclude: noice.nvim

	-- To-do
	-- quarto.nvim
	-- otter.nvim

	-- [[ Color Schemes ]]
	-- Uncomment out *one* of the following line
	-- Alternatively, can set enabled = false for the ones I'm not using
	-- But I'm not 100% whether I can set that here (i.e., require(import).opts.enabled = false)
	-- require 'plugins.colorschemes.tokyonight',
	require("plugins.colorschemes.catppuccin"),
	-- require("plugins.colorschemes.rose-pine"),
	-- require 'plugins.colorschemes.gruvbox',
	-- require 'plugins.colorschemes.kanagawa',
})
