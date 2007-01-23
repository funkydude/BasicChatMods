scmTimestamps = {
	hook = {}
}

SCM_TIMESTAMP_FORMAT = "%X"
SCM_TIMESTAMP_COLOR = "777777"
SCM_TIMESTAMP_OUTPUT_FORMAT = "(%s)|r %s"

local _G = getfenv(0)

local idCFAddMessage = function(frame, text, red, green, blue, id)
	text = string.format("|cff"..SCM_TIMESTAMP_COLOR..SCM_TIMESTAMP_OUTPUT_FORMAT, date(SCM_TIMESTAMP_FORMAT), text or "")
	scmTimestamps.hook[frame:GetName()](frame, text, red, green, blue, id)
end

function scmTimestamps:Enable()
	local cf
	for i = 1, 7 do
		local frameName = "ChatFrame"..i
		cf = _G[frameName]
		self.hook[frameName] = cf.AddMessage
		cf.AddMessage = idCFAddMessage
	end
end

function scmTimestamps:Disable()
	for i = 1, 7 do
		local frameName = "ChatFrame" .. i
		_G[frameName].AddMessage = self.hook[frameName]
	end
end

scmTimestamps:Enable()
