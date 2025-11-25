local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local entry_display = require("telescope.pickers.entry_display")
local previewers = require("telescope.previewers")
local conf = require("telescope.config").values
local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")

-- NOTE: Current status is that I've implemented most everything below. The main points
-- for further development are the implementation of item type icons (at the very end)
-- and dealing with attachments and/or notes.

-- Actually, we can, theoretically, directly copy telescope-zotero for everything in the
-- telescope part of the setup *except* for the get_items() function.
-- So, assume we do that. Now what does the get_items() function have to look like:

-- Wait, that's not entirely true; we'll also want to probably change the entry maker in
-- some minor ways and then more subsantially change the attach_mappings behavior of the
-- current picker, largely by making changes to insert_entry, I think.

-- Otherwise, append the entry to the bib file at bib_path
-- I think what we do is have get_items() just read the json file + turn it into entries
-- then entry_to_bib_entry() will just reserialize the appropriate table entry to json

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

local items = M.get_items(lib_path)

vim.print(items)

---Insert entry into references file
---@param entry table Citation entry to insert
---@param insert_key_fn function Function that formats citation entry
---@param locate_bib_fn function Functoin that locate references bib file
local insert_entry = function(entry, insert_key_fn, locate_bib_fn)
	-- Insert selected citation in file
	local citekey = entry.value["citation-key"]
	local insert_key = insert_key_fn(citekey)
	vim.api.nvim_put({ insert_key }, "", false, true)

	-- Get bib file path
	local bib_path = nil
	if type(locate_bib_fn) == "string" then
		bib_path = locate_bib_fn
	elseif type(locate_bib_fn) == "function" then
		bib_path = locate_bib_fn()
	end
	if bib_path == nil then
		vim.notify_once("[zotero] Could not find a bibliography file", vim.log.levels.WARN)
		return
	end
	bib_path = vim.fn.expand(bib_path)

	-- Check if bib file exists at bib_path
	local ok, lines = pcall(io.lines, bib_path)
	if not ok then
		if vim.fn.confirm("Bibliography file missing. Create '" .. bib_path .. "'?", "&Yes\n&No", 1) == 1 then
			vim.fn.writefile({}, bib_path)
			lines = io.lines(bib_path)
		end
	end

	-- Check if citation has already been placed in bib file at bib_path
	-- NOTE: will need to check whether this still works with json csl.
	for line in lines do
		if string.match(line, "^@") and string.match(line, citekey) then
			return
		end
	end

	-- Otherwise, append the entry to the bib file at bib_path
	local bib_entry = vim.json.encode(entry, { indent = "  " })
	local file = io.open(bib_path, "a")
	if file == nil then
		vim.notify("[zotero] Could not open " .. bib_path .. " for appending", vim.log.levels.ERROR)
		return
	end
	file:write(bib_entry)
	file:close()
	vim.print("wrote " .. citekey .. " to " .. bib_path)
end

-- need to make this output work with the picker (make_entry)
-- and change from using entry_to_bib_entry() to just vim.json.encode()
-- (or maybe using the json.encode() within entry_to_bib_entry()).

-- NOTE: Switching to a pure CSL workflow means I can no longer (easily) access
-- attachments for any given entry. I don't think I care that much about this,
-- but worth noting explicitly.

---Extract year for date entry
---@param date string Date to parse
---@return string year Year of date entry or " ¿? " if not found
local function extract_year(date)
	local year = date:match("(%d%d%d%d)")
	if year ~= nil then
		return year
	else
		return " ¿? "
	end
end

local function make_entry(pre_entry)
	-- Process entry
	local authors = pre_entry.author or {}
	local first_auth = authors[1] or {}
	local family_name = first_auth.family or "NA"
	local year = pre_entry.issued["date-parts"][1][1] or "NA"

	-- Set icon by item type

	-- Create display maker
	local displayer = entry_display.create({
		separator = " ",
		items = {
			-- { width = 3 },
			{ width = 24, right_justify = true },
			{ remaining = true },
		},
	})

	local function make_display(_)
		return displayer({
			-- { icon, M.config.picker.hlgroups.icons },
			{ family_name .. ", " .. year, M.config.picker.hlgroups.author_year },
			{ pre_entry.title, M.config.picker.hlgroups.title },
		})
	end

	-- Return entry maker
	local ordinal = string.format("%s %s %s %s", family_name, year, pre_entry.title)
	return {
		value = pre_entry,
		display = make_display,
		ordinal = ordinal,
		preview_command = function(entry, bufnr)
			local bib_entry = vim.json.encode(entry, { indent = "  " }) -- Not 100% that this opt exists
			local lines = vim.split(bib_entry, "\n")
			vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
			vim.api.nvim_set_option_value("filetype", "json", { buf = bufnr })
		end,
	}
end

M.picker = function(opts)
	opts = opts or {}
	local ft_options = M.config.ft[vim.bo.filetype] or M.config.ft.default --[[@as Zotero.FileType]]
	pickers
		.new(opts, {
			prompt_title = "Zotero library",
			finder = finders.new_table({
				results = get_items(M.config.library),
				entry_maker = make_entry,
			}),
			sorter = conf.generic_sorter(opts),
			previewer = previewers.display_content.new(opts),
			attach_mappings = function(prompt_bufnr, map)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local entry = action_state.get_selected_entry()
					insert_entry(entry, ft_options.insert_key_formatter, ft_options.locate_bib)
				end)
				-- Update the mapping to open PDF or DOI
				-- I've deleted the code to do this, since I'm not dealing with PDF
				-- attachments; however, this reminds me that we could be using this
				-- to open follow a DOI number (or URL) if present.
				return true
			end,
		})
		:find()
end

-- This might be worth doing eventually, but I'm not gonna bother any more now.
local icons = {
	dataset = "",
	website = "󰖟",
	article = "󰈙",
	book = "", -- Maybe an alternative book one?
	report = "󰠮",
	working_paper = "󰷈",
}
