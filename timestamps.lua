scmTimestamps = AceLibrary("AceAddon-2.0"):new("AceHook-2.1")

SCM_TIMESTAMP_FORMAT = "%X"
SCM_TIMESTAMP_COLOR = "777777"
SCM_TIMESTAMP_OUTPUT_FORMAT = "(%s)|r %s"

local _G = getfenv(0)

function scmTimestamps:OnEnable()
	for i=1,NUM_CHAT_WINDOWS do
		self:Hook(_G["ChatFrame"..i], "AddMessage", true)
	end
end

function scmTimestamps:AddMessage(frame, text, ...)
	text = string.format("|cff"..SCM_TIMESTAMP_COLOR..SCM_TIMESTAMP_OUTPUT_FORMAT, date(SCM_TIMESTAMP_FORMAT), text or "")
	self.hooks[frame].AddMessage(frame, text, ...)
end
