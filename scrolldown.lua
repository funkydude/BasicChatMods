
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
	if frame:AtBottom() then
		_G[n.."ButtonFrameBottomButton"]:Hide()
	else
		_G[n.."ButtonFrameBottomButton"]:Show()
	end
end

do
	ChatFrame1ButtonFrameBottomButton:RegisterEvent("UPDATE_TICKET") --later than login
	ChatFrame1ButtonFrameBottomButton:SetScript("OnEvent", function(frame)
		if not ChatFrame1ButtonFrame:IsShown() then --Don't load this module if button hide module is disabled
			for i=1, 10 do
				local btn = _G[format("%s%d%s", "ChatFrame", i, "ButtonFrameBottomButton")]
				btn:ClearAllPoints()
				local cf = btn:GetParent():GetParent()
				cf:HookScript("OnMouseWheel", showFunc)
				cf:HookScript("OnShow", showFunc)
				btn:SetParent(cf)
				btn:SetPoint("TOPRIGHT")
				btn:SetScript("OnClick", scrollFunc)
				btn:SetSize(20, 20)
				btn:Hide()
			end
		else
			scrollFunc = nil
			showFunc = nil
		end
		frame:UnregisterEvent("UPDATE_TICKET")
		frame:SetScript("OnEvent", nil)
	end)
end

