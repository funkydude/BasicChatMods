
--[[     EditBox Module     ]]--

local _, BCM = ...
BCM.modules[#BCM.modules+1] = function()
	if bcmDB.BCM_EditBox then return end

	--Classic mode hides the editbox when not in use, IM mode fades it out
	--since we move the editbox above the chat tabs, we don't want it always showing
	SetCVar("chatStyle", "classic")
	for i=1, BCM.chatFrames do
		local cf_text = format("%s%d", "ChatFrame", i)
		local eb_text = cf_text.."EditBox"
		local cf, eb = _G[cf_text], _G[eb_text]
		eb:ClearAllPoints()
		eb:SetPoint("BOTTOMLEFT",  cf, "TOPLEFT",  -5, 0)
		eb:SetPoint("BOTTOMRIGHT", cf, "TOPRIGHT", 5, 0)
		eb:Hide() --call this incase we're just changing to classic mode for the first time

		if bcmDB.noEditBoxBG then
			_G[eb_text.."Left"]:Hide()
			_G[eb_text.."Mid"]:Hide()
			_G[eb_text.."Right"]:Hide()
		end
	end
end

