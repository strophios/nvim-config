-- [[ Setting options ]]
-- See `:help vim.o`
-- For more options, see `:h option-list`

-- Proper colors
vim.opt.termguicolors = true

-- Line numbers and relative line numbers
vim.o.number = true
vim.o.relativenumber = true

vim.o.mouse = "a" -- Enable mouse mode
vim.o.showmode = false -- Don't show mode, since it'll be in the status line

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)

-- Indents, tabs, and linebreaks
vim.o.breakindent = true
vim.o.smartindent = true

-- These will be overidden in individual buffers by guess-indent,
-- but it's good to have sensible defaults for new files.
local tabsize = 2
vim.o.expandtab = true
vim.o.shiftwidth = tabsize
vim.o.tabstop = tabsize

vim.o.linebreak = true -- Ensure wrapping lines don't split words

-- Other options
vim.o.undofile = true -- Save undo history
vim.o.ignorecase = true -- Case-insensitive searching
vim.o.smartcase = true -- UNLESS \C or one or more capital letters in the search term
vim.o.signcolumn = "yes" -- Keep signcolumn on by default

vim.o.updatetime = 250 -- Decrease update time
vim.o.timeoutlen = 300 -- Decrease mapped sequence wait time

-- How to show autocomplete menu
vim.opt.completeopt = "menuone,noinsert,popup" --NOTE: Currently testing, previously "menu,popup"

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

vim.o.inccommand = "split" -- Preview substitutions live, as you type!
vim.o.cursorline = true -- Show which line your cursor is on
vim.o.scrolloff = 10 -- Minimal number of screen lines to keep above and below the cursor.

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.o.confirm = true

-- Setup options for displaying diagnostics
-- Desired behavior is to show diagnostic messages on virtual lines (not as virtual text on the same line),
-- but only on the line where the cursor currently is. So we can use the signs column on the left to see where
-- errors and warnings are, but only see the details (and therefore have them cluttering up the document) when
-- I'm on the line to look at them.
vim.diagnostic.config({ virtual_lines = { current_line = true } }) -- I *think* this does what I want, but it's possible it's not quite right.

-- NOTE: Potential alternative would be to keep showing all diagnostics in your immediate surroundings, so if
-- you have to navigate a few lines away to fix something, the message doesn't go away while you do it. Could
-- conceivably do this using Treesitter? Like, display diagnostics within the immediate scope or something.
--
--  See `:help 'list'`
--  and `:help 'listchars'`
--
--  Notice listchars is set using `vim.opt` instead of `vim.o`.
--  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
--   See `:help lua-options`
--   and `:help lua-options-guide`
vim.o.list = false
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- vim: ts=2 sts=2 sw=2 et
