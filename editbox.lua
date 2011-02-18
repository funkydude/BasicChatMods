
--[[     EditBox Module     ]]--

local _, f = ...
f.functions[#f.functions+1] = function()
	if bcmDB.BCM_EditBox then return end

	for i =1, 10 do
		local eb =  _G[format("%s%d%s", "ChatFrame", i, "EditBox")]
		local cf = _G[format("%s%d", "ChatFrame", i)]
		eb:ClearAllPoints()
		eb:SetPoint("BOTTOMLEFT",  cf, "TOPLEFT",  -5, 0)
		eb:SetPoint("BOTTOMRIGHT", cf, "TOPRIGHT", 5, 0)
	end
end

