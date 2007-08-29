scmTimestamps = AceLibrary("AceAddon-2.0"):new("AceHook-2.1")

SCM_TIMESTAMP_FORMAT = "%X"
SCM_TIMESTAMP_COLOR = "777777"
SCM_TIMESTAMP_OUTPUT_FORMAT = "[%s]|r %s"

local format = nil

function scmTimestamps:OnEnable()
	format = "|cff"..SCM_TIMESTAMP_COLOR..SCM_TIMESTAMP_OUTPUT_FORMAT

	local _G = getfenv(0)
	for i = 1, 2 do
		self:Hook(_G["ChatFrame"..i], "AddMessage", true)
	end
end

function scmTimestamps:AddMessage(frame, text, ...)
	if type(text) == "string" then
		text = format:format(date(SCM_TIMESTAMP_FORMAT), text)
	end
	self.hooks[frame].AddMessage(frame, text, ...)
end
