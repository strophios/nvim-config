local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local entry_display = require("telescope.pickers.entry_display")
local previewers = require("telescope.previewers")
local conf = require("telescope.config").values
local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")

-- Scratch file for testing miscellaneous piece of code during plugin or config dev

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
