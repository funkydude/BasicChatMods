
--[[     EditBox Module     ]]--

local _, BCM = ...
BCM.modules[#BCM.modules+1] = function()
	if bcmDB.BCM_EditBox then return end

	--Classic mode hides the editbox when not in use, IM mode fades it out
	--since we move the editbox above the chat tabs, we don't want it always showing
	SetCVar("chatStyle", "classic")
	BCM.chatFuncsPerFrame[#BCM.chatFuncsPerFrame+1] = function(n)
		local eb_text = n.."EditBox"
		local cf, eb = _G[n], _G[eb_text]
		if not bcmDB.editBoxOnBottom then
			eb:ClearAllPoints()
			eb:SetPoint("BOTTOMLEFT", cf, "TOPLEFT", -5, -2.0000002384186)
			eb:SetPoint("BOTTOMRIGHT", cf, "TOPRIGHT", 5, -2.0000002384186)
		end
		eb:Hide() --call this incase we're just changing to classic mode for the first time

		if bcmDB.noEditBoxBG then
			_G[eb_text.."Left"]:Hide()
			_G[eb_text.."Mid"]:Hide()
			_G[eb_text.."Right"]:Hide()
		end

		eb:SetScale(bcmDB.editBoxScale or 1)
	end
end

