Timestamps = {
	hook = {}
}

local _G = getfenv(0)

local idCFAddMessage = function(frame, text, red, green, blue, id)
	text = string.format("|cff777777(%s)|r %s", date("%X"), text or "")
	Timestamps.hook[frame:GetName()](frame, text, red, green, blue, id)
end

function Timestamps:Enable()
	local cf
	for i = 1, 7 do
		local frameName = "ChatFrame"..i
		cf = _G[frameName]
		self.hook[frameName] = cf.AddMessage
		cf.AddMessage = idCFAddMessage
	end
end

function Timestamps:Disable()
	for i = 1, 7 do
		local frameName = "ChatFrame" .. i
		_G[frameName].AddMessage = self.hook[frameName]
	end
end

Timestamps:Enable()
