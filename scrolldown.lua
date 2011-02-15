
--[[		Scrolldown Module		]]--

local clickFunc = function(frame) frame:GetParent():ScrollToBottom() frame:Hide() end
local _, f = ...
f.functions[#f.functions+1] = function()
	if bcmDB.BCM_ScrollDown or bcmDB.BCM_ButtonHide then
		clickFunc = nil
		return
	end

	FloatingChatFrame_OnMouseScroll = function(frame, d)
		if d then
			if d > 0 then
				if IsShiftKeyDown() then
					frame:ScrollToTop()
				elseif IsControlKeyDown() then
					frame:PageUp()
				else
					frame:ScrollUp()
				end
			elseif d < 0 then
				if IsShiftKeyDown() then
					frame:ScrollToBottom()
				elseif IsControlKeyDown() then
					frame:PageDown()
				else
					frame:ScrollDown()
				end
			end
		end
		local n = frame:GetName()
		if frame:AtBottom() then
			_G[n.."ButtonFrameBottomButton"]:Hide()
		else
			_G[n.."ButtonFrameBottomButton"]:Show()
		end
	end
	for i=1, 10 do
		local btn = _G[format("%s%d%s", "ChatFrame", i, "ButtonFrameBottomButton")]
		btn:ClearAllPoints()
		local cf = btn:GetParent():GetParent()
		cf:HookScript("OnShow", FloatingChatFrame_OnMouseScroll)
		btn:SetParent(cf)
		btn:SetPoint("TOPRIGHT")
		btn:SetScript("OnClick", clickFunc)
		btn:SetSize(20, 20)
		btn:Hide()
	end
end

