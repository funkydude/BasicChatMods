
--[[		Timestamp Module		]]--
local bcmTimestamps = AceLibrary("AceAddon-2.0"):new("AceHook-2.1")



--[[		Timestamp Color		]]--
local COLOR = "777777"


local date = date
local fmt = string.format
function bcmTimestamps:OnEnable()
	local _G = getfenv(0)
	for i = 1, 2 do
		self:Hook(_G[fmt("%s%d", "ChatFrame", i)], "AddMessage", true)
	end
end

local msg = "|cff"..COLOR.."[%s]|r %s"
function bcmTimestamps:AddMessage(frame, text, ...)
	text = fmt(msg, date("%X"), text)
	self.hooks[frame].AddMessage(frame, text, ...)
end
