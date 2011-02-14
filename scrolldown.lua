
--[[		Scrolldown Module		]]--

--[[
	No customization here.
	Simple module to show the "scroll down" button
	when not at the bottom of the chat frame.
	Moves the Blizzard one and resizes it.
]]--

local clickFunc = function(frame) frame:GetParent():ScrollToBottom() frame:Hide() end
local showFunc = function(frame, d)
	if d and GetCVarBool("chatMouseScroll") then
		FloatingChatFrame_OnMouseScroll(frame, d)
	end
	local n = frame:GetName()
	if frame:AtBottom() then
		_G[n.."ButtonFrameBottomButton"]:Hide()
	else
		_G[n.."ButtonFrameBottomButton"]:Show()
	end
end

local _, f = ...
f.functions[#f.functions+1] = function()
	if bcmDB.scrolldownDisabled then return end
	if not bcmDB.buttonHideDisabled then --Don't load this module if button hide module is disabled
		for i=1, 10 do
			local btn = _G[format("%s%d%s", "ChatFrame", i, "ButtonFrameBottomButton")]
			btn:ClearAllPoints()
			local cf = btn:GetParent():GetParent()
			cf:SetScript("OnMouseWheel", showFunc)
			cf:HookScript("OnShow", showFunc)
			btn:SetParent(cf)
			btn:SetPoint("TOPRIGHT")
			btn:SetScript("OnClick", clickFunc)
			btn:SetSize(20, 20)
			btn:Hide()
		end
	else
		scrollFunc = nil
		showFunc = nil
	end
end

