bcmTimestamps = AceLibrary("AceAddon-2.0"):new("AceHook-2.1")
local bcmTimestamps = bcmTimestamps

local BCM_TIMESTAMP_FORMAT = "%X"
local BCM_TIMESTAMP_COLOR = "777777"
local BCM_TIMESTAMP_OUTPUT_FORMAT = "[%s]|r %s"

local format = nil

function bcmTimestamps:OnEnable()
	format = "|cff"..BCM_TIMESTAMP_COLOR..BCM_TIMESTAMP_OUTPUT_FORMAT

	local _G = getfenv(0)
	for i = 1, 2 do
		self:Hook(_G[("%s%d"):format("ChatFrame", i)], "AddMessage", true)
	end
end

function bcmTimestamps:AddMessage(frame, text, ...)
	if type(text) == "string" then
		text = format:format(date(BCM_TIMESTAMP_FORMAT), text)
	end
	self.hooks[frame].AddMessage(frame, text, ...)
end
