
--[[     EditBox Module     ]]--

local _, f = ...
f.functions[#f.functions+1] = function()
	if bcmDB.BCM_EditBox then return end

	--Classic mode hides the editbox when not in use, IM mode fades it out
	--since we move the editbox above the chat tabs, we don't want it always showing
	SetCVar("chatStyle", "classic")
	for i =1, 10 do
		local eb =  _G[format("%s%d%s", "ChatFrame", i, "EditBox")]
		local cf = _G[format("%s%d", "ChatFrame", i)]
		eb:ClearAllPoints()
		eb:SetPoint("BOTTOMLEFT",  cf, "TOPLEFT",  -5, 0)
		eb:SetPoint("BOTTOMRIGHT", cf, "TOPRIGHT", 5, 0)
		eb:Hide() --call this incase we're just changing to classic mode for the first time
	end
end

