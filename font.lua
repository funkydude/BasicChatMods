
--[[     Font Module     ]]--

local _, BCM = ...
BCM.modules[#BCM.modules+1] = function()
	if bcmDB.BCM_Font then bcmDB.fontname, bcmDB.fontsize, bcmDB.fontflag = nil, nil, nil return end

	for i=1, BCM.chatFrames do
		local cF = _G[format("%s%d", "ChatFrame", i)]
		local cFE = _G[format("%s%d%s", "ChatFrame", i, "EditBox")]
		local name, size = cF:GetFont()
		if i == 1 then
			--remove defaults
			if name == bcmDB.fontname then bcmDB.fontname = nil end
			if bcmDB.fontsize and (tostring(size)):find(bcmDB.fontsize..".", nil, true) then bcmDB.fontsize = nil end
		end

		cF:SetFont(bcmDB.fontname or name, bcmDB.fontsize or size, bcmDB.fontflag)
		cFE:SetFont(bcmDB.fontname or name, bcmDB.fontsize or size, bcmDB.fontflag)
	end
end

