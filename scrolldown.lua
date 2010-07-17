
--[[		Scrolldown Module		]]--

--[[
	No customization here.
	Simple module to show the "scroll down" button
	when not at the bottom of the chat frame.
	Moves the Blizzard one and resizes it.
]]--

local scrollFunc = function(frame) frame:GetParent():ScrollToBottom() frame:Hide() end
local showFunc = function(frame)
	local n = frame:GetName()
	if frame:GetCurrentScroll() > 0 then
		_G[n.."ButtonFrameBottomButton"]:Show()
	else
		_G[n.."ButtonFrameBottomButton"]:Hide()
	end
end

do
	local f = ChatFrame1ButtonFrameBottomButton
	f:RegisterEvent("PLAYER_LOGIN")
	f:SetScript("OnEvent", function()
		for i=1, 10 do
			local btn = _G[format("%s%d%s", "ChatFrame", i, "ButtonFrameBottomButton")]
			btn:ClearAllPoints()
			local cf = btn:GetParent():GetParent()
			cf:HookScript("OnMouseWheel", showFunc)
			btn:SetParent(cf)
			btn:SetPoint("TOPRIGHT")
			btn:SetScript("OnClick", scrollFunc)
			btn:SetSize(20, 20)
			btn:Hide()
		end
		f:SetScript("OnEvent", nil)
		f:UnregisterEvent("PLAYER_LOGIN")
		f = nil
	end)
end

