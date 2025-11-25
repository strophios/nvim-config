-- Scratch file for testing miscellaneous piece of code during plugin or config dev
local iron = require("iron.core")
local view = require("iron.view")

vim.print(view.center("80%", "70%"))

local tmp_func = function()
	-- local win_func = view.center(120) -- view.center returns a function which, when called, returns the config for the float to be called
	-- So we create a wrapper that calls it, adds to the output, and returns the new config, and we return that function to repl_open_cmd
	-- return function()
	-- 	local win_opts = win_func()
	-- 	-- win_opts.border = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" } -- Taking this from the telescope default
	--
	-- 	return win_opts
	-- end
	-- return win_func
	return view.center("80%", "70%")
end

local win_opts = view.center("80%", "70%")()
win_opts.border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" } -- Taking this from the telescope default
win_opts.border = "rounded"

vim.api.nvim_open_win(4, false, win_opts)
vim.print(view.center("80%", "70%")())
vim.print(tmp_func()())

local M = {}

function M.get_items(library)
	library = vim.fs.abspath(library)
	local file = io.open(library, "r")
	if file then
		local lib_content = file:read("*all")
		file:close()

		local ok, lib_items = pcall(vim.json.decode, lib_content)

		if ok then
			return lib_items
		else
			vim.notify("[zotero] could not decode JSON.", vim.log.levels.ERROR)
		end
	else
		vim.notify("[zotero] Could not open " .. library .. " for reading", vim.log.levels.ERROR)
	end
end

local lib_path = "/users/strophios/Documents/00_test_lib.json"
-- local lib_path = "/users/strophios/Zotero/library.json"

local items = M.get_items(lib_path)

-- First layer: 5 numerically indexed items
-- Second layer: the following keys:
-- citation-key
-- accessed
-- language
-- type
-- abstract
-- container-title-short
-- author
-- id
-- ISSN
-- title-short
-- issued
-- page
-- URL
-- container-title
-- DOI
-- title
-- source
-- vim.print(items[1].issued)

local items = { citekey = "Matthews2025", title = "Test title", date = "2025-10-11" }

local formatted = string.format(
	[[
  citekey: %s
  title: %s
  date: %s
  ]],
	items.citekey,
	items.title,
	items.date
)

print(formatted)

-- for n = 1, table.maxn(items) do
-- 	-- print(items[n]["citation-key"])
-- 	if items[n].issued == nil then
-- 		vim.print(items[n])
-- 	else
-- 		print(vim.json.encode(items[n], { indent = "  " }))
-- 	end
-- end
