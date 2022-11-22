local M = {}
local icons = require("utils.icons")


-- MARK: Private local functions
local notified = {}

---Try to use nvim-notify to notify the message
---Fallback to vim.notify if nvim-notify is not installed
local function send_notify(message, level, opts)
	local nvim_notify = Utils.require("notify", "All notification will be sent using default vim.notify instead.")

	local notify_fn = nvim_notify and nvim_notify or vim.notify
	notify_fn(message, level, opts)
end

-- MARK: Public module functions

---Send a notification when entered a custom mode
---@param name string: the name of the submode that are entered
---@param icon string: the icon for the submode
function M.enter_submode(name, icon)
	local message = icons.enter .. " " .. icon .. name .. " submode"
	M.minimal(message, vim.log.levels.INFO, {
		hide_from_history = true,
	})
end

---Send a notification when exited from a custom mode
---@param name string: the name of the submode that are exited
---@param icon string: the icon for the submode
function M.exit_submode(name, icon)
	local message = icons.exit .. " " .. icon .. " Exited " .. name .. " submode"
	M.minimal(message, vim.log.levels.INFO, {
		hide_from_history = true,
	})
end

---Send a one-time notification when plugin is not loaded properly
---@param name string: the name of the plugin that isn't loaded
---@param ... any?: additional details to be included in the notification
function M.failed_to_load(name, ...)
	M.error_once("Failed to load " .. name, "Make sure " .. name .. " is installed.", ...)
end

---Send an error notification
---@param title string?: the title of the error; if nil, then a minimal style notificaiton will be sent
---@param message string: the body of the error
---@param ... any?: additional informaiton to be included in the error; each item will be displayed in a new line
function M.error(title, message, ...)
	M.auto(title, vim.log.levels.ERROR, nil, message, ...)
end

--Send an one-time error notification
---@param title string?: the title of the error; if nil, then a minimal style notificaiton will be sent
---@param message string: the body of the error
---@param ... any?: additional informaiton to be included in the error; each item will be displayed in a new line
function M.error_once(title, message, ...)
	M.auto(title, vim.log.levels.ERROR, { once = true }, message, ...)
end

---Send an error notification
---@param title string?: the title of the error; if nil, then a minimal style notificaiton will be sent
---@param message string: the body of the error
---@param ... any?: additional informaiton to be included in the error; each item will be displayed in a new line
function M.warn(title, message, ...)
	M.auto(title, vim.log.levels.WARN, nil, message, ...)
end

--Send an one-time error notification
---@param title string?: the title of the error; if nil, then a minimal style notificaiton will be sent
---@param message string: the body of the error
---@param ... any?: additional informaiton to be included in the error; each item will be displayed in a new line
function M.warn_once(title, message, ...)
	M.auto(title, vim.log.levels.WARN, { once = true }, message, ...)
end

---Send an info notification
---@param title string?: the title of the info; if nil, then a minimal style notificaiton will be sent
---@param message string: the body of the info
---@param ... any?: additional informaiton to be included in the info; each item will be displayed in a new line
function M.info(title, message, ...)
	M.auto(title, vim.log.levels.INFO, nil, message, ...)
end

--Send an one-time info notification
---@param title string?: the title of the info; if nil, then a minimal style notificaiton will be sent
---@param message string: the body of the info
---@param ... any?: additional informaiton to be included in the info; each item will be displayed in a new line
function M.info_once(title, message, ...)
	M.auto(title, vim.log.levels.INFO, { once = true }, message, ...)
end

---Send a notification
---@param title string?: the title of the notification; if nil, then a minimal notification will be sent
---@param level number?: the level of the notificaiotn; default is INFO
---@param opts table?: the options for the notification
---@param message string: the body of the notification; if nil or empty, the notification won't be sent
---@param ... any?: additional information to be included in the notification; each item will be seperated by a new line
function M.auto(title, level, opts, message, ...)
	message = table.concat({ message, ... }, "\n")

	if title then
		M.default(title, message, level, opts)
		return
	end

	M.minimal(message, level, opts)
end

-- Send quick notification with minial style
-- Also add padding on both sides of messages to make it look nicer
-- @param message string: the body of the notification; can't be nil nor empty
-- @param level number?: the logging level of this notification
-- @param opts table?: additional nvim-notify options for this notification
function M.simple(title, message, level, opts)
	opts = opts or {}

	opts = vim.tbl_deep_extend("force", {
		timeout = 500,
		render = "simple",
	}, opts or {})

	M.default(title, message, level, opts)
end

-- Send quick notification with minial style
-- Also add padding on both sides of messages to make it look nicer
-- @param message string: the body of the notification; can't be nil nor empty
-- @param level number?: the logging level of this notification
-- @param opts table?: additional nvim-notify options for this notification
function M.minimal(message, level, opts)
	opts = opts or {}

	opts = vim.tbl_deep_extend("force", {
		timeout = 500,
		render = "minimal",
	}, opts or {})

	M.default("", " " .. message .. " ", level, opts)
end

---Send a notification with default style and settings
---@param title string?: the title for the notification
---@param message string: the body of the notification; can't be nil nor empty
---@param level number?: the logging level of this notification
---@param opts table?: additional nvim-notify options for this notification
function M.default(title, message, level, opts)
	-- Ignore if message is nil or empty
	if not message or message == "" then
		return
	end

	-- Setup default values for parameters
	level = level or vim.log.levels.INFO
	opts = vim.tbl_deep_extend("force", {
		render = "default",
		title = title or "",
	}, opts or {})

	if opts.once and notified[title .. message] then
		return
	end

	notified[title .. message] = true
	opts.once = nil

	-- Send the notification after nvim-notify is fully configured
	vim.schedule(function()
		send_notify(message, level, opts)
	end)
end

return M
