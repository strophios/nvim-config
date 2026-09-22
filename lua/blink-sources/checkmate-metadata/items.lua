-- pattern: Functional Core
--
-- Pure construction of blink.cmp completion items for checkmate.nvim metadata
-- tags. No buffer, config, or checkmate access here; the shell (init.lua)
-- gathers those and passes plain data in.

local M = {}

---@class checkmate_metadata.TagSpec
---@field name string canonical tag name, e.g. "due"
---@field sort_order? integer checkmate's display order; nil sorts last
---@field default_value string value pre-filled inside the parens ("" for none)

---Locate the `@` that a metadata completion should replace.
---
---Only an `@` at the start of the line or after whitespace counts, so that
---`foo@bar` (emails, handles mid-word) does not trigger. Everything between
---the `@` and the cursor must be tag-name characters.
---@param line string full line text
---@param cursor_col integer 0-indexed cursor column (number of bytes before the cursor)
---@return integer|nil trigger_col 0-indexed column of the `@`, or nil if none applies
function M.find_trigger_col(line, cursor_col)
	local before = line:sub(1, cursor_col)
	local at = before:match("()@[%w_%-]*$")
	if not at then
		return nil
	end
	if at > 1 and not before:sub(at - 1, at - 1):match("%s") then
		return nil
	end
	return at - 1
end

---Escape text for use inside an LSP snippet placeholder.
---@param text string
---@return string
local function escape_snippet_text(text)
	return (text:gsub("[%$}\\]", "\\%0"))
end

---Build the LSP snippet body for a tag: `@tag($1)` or `@tag(${1:default})`.
---@param name string
---@param default_value string
---@return string
function M.snippet_body(name, default_value)
	if default_value == "" then
		return "@" .. name .. "($1)"
	end
	return "@" .. name .. "(${1:" .. escape_snippet_text(default_value) .. "})"
end

---Stable ordering: checkmate's sort_order first, then name.
---@param a checkmate_metadata.TagSpec
---@param b checkmate_metadata.TagSpec
---@return boolean
local function tag_less_than(a, b)
	local a_so = a.sort_order or math.huge
	local b_so = b.sort_order or math.huge
	if a_so ~= b_so then
		return a_so < b_so
	end
	return a.name < b.name
end

---Build completion items, one per tag, each replacing `@...` from trigger_col to cursor_col.
---@param tags checkmate_metadata.TagSpec[]
---@param row integer 0-indexed line number
---@param trigger_col integer 0-indexed column of the `@`
---@param cursor_col integer 0-indexed cursor column at fetch time
---@return lsp.CompletionItem[]
function M.build_items(tags, row, trigger_col, cursor_col)
	local sorted = vim.list_slice(tags)
	table.sort(sorted, tag_less_than)

	local range = {
		start = { line = row, character = trigger_col },
		["end"] = { line = row, character = cursor_col },
	}

	local items = {}
	for i, tag in ipairs(sorted) do
		items[#items + 1] = {
			label = "@" .. tag.name,
			filterText = tag.name,
			-- blink sorts by fuzzy score first, then sortText; with an empty
			-- keyword all scores tie, so this preserves checkmate's order.
			sortText = string.format("%04d", i),
			detail = "checkmate metadata",
			kind = vim.lsp.protocol.CompletionItemKind.Snippet,
			insertTextFormat = vim.lsp.protocol.InsertTextFormat.Snippet,
			textEdit = {
				newText = M.snippet_body(tag.name, tag.default_value),
				range = range,
			},
		}
	end
	return items
end

return M
