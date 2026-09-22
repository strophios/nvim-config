-- pattern: Imperative Shell
--
-- blink.cmp source offering checkmate.nvim metadata tags (`@due(...)`,
-- `@priority(...)`, ...) as snippet completions, triggered by `@`.
--
-- Only active in buffers where checkmate itself is active (i.e. files matching
-- checkmate's `files` patterns), so ordinary markdown is unaffected. Inserting
-- text this way bypasses checkmate's `on_add` hooks by design; use checkmate's
-- own metadata keymaps when a hook matters (currently only the default @done).

local items = require("blink-sources.checkmate-metadata.items")

local EMPTY = { items = {}, is_incomplete_forward = false, is_incomplete_backward = false }

---@class blink_sources.CheckmateMetadata : blink.cmp.Source
local source = {}
source.__index = source

function source.new()
	return setmetatable({}, source)
end

---@return boolean
function source:enabled()
	local ok, buffer = pcall(require, "checkmate.buffer")
	if not ok then
		return false
	end
	return buffer.is_active(vim.api.nvim_get_current_buf())
end

---@return string[]
function source:get_trigger_characters()
	return { "@" }
end

---Resolve a tag's pre-filled value via checkmate's `get_value`, tolerating failures.
---@param name string
---@param props checkmate.MetadataProps
---@return string
local function resolve_default_value(name, props)
	if type(props.get_value) ~= "function" then
		return ""
	end
	local ok, value = pcall(props.get_value)
	if not ok then
		vim.notify(
			string.format("checkmate-metadata: get_value for @%s failed: %s", name, tostring(value)),
			vim.log.levels.WARN
		)
		return ""
	end
	return value ~= nil and tostring(value) or ""
end

---@return checkmate_metadata.TagSpec[]|nil
local function gather_tags()
	local ok, config = pcall(require, "checkmate.config")
	if not ok or type(config.options) ~= "table" or type(config.options.metadata) ~= "table" then
		return nil
	end
	local tags = {}
	for name, props in pairs(config.options.metadata) do
		if type(name) == "string" and type(props) == "table" then
			tags[#tags + 1] = {
				name = name,
				sort_order = props.sort_order,
				default_value = resolve_default_value(name, props),
			}
		end
	end
	return tags
end

---@param ctx blink.cmp.Context
---@param callback fun(response: blink.cmp.CompletionResponse)
function source:get_completions(ctx, callback)
	local row, cursor_col = ctx.cursor[1] - 1, ctx.cursor[2]
	local trigger_col = items.find_trigger_col(ctx.line, cursor_col)
	if not trigger_col then
		callback(EMPTY)
		return
	end

	local tags = gather_tags()
	if not tags then
		callback(EMPTY)
		return
	end

	callback({
		items = items.build_items(tags, row, trigger_col, cursor_col),
		is_incomplete_forward = false,
		is_incomplete_backward = false,
	})
end

return source
