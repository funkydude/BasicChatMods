
--[[		Timestamp Color		]]--
local COLOR = "777777"

--[[		Timestamp Module		]]--
local hooks = {}
local date = date
local h = nil
local fmt = string.format
local _G = getfenv(0)

local msg = "|cff"..COLOR.."[%s]|r %s"
local function AddMessage(frame, text, ...)
	text = fmt(msg, date("%X"), text)

	return hooks[frame](frame, text, ...)
end

--[[
	Here we stamp ChatFrame1 and 2 only.
	Change for i = 1, 2 to for i = 1, x
	x being the amount of chat frames you want to enable stamps for.
	The max chat frames is 7
	e.g.
	for i = 1, 7 do
]]--
for i = 1, 2 do
	h = _G[fmt("%s%d", "ChatFrame", i)]
	hooks[h] = h.AddMessage
	h.AddMessage = AddMessage
end
