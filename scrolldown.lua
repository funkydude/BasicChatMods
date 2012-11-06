
--[[     Scrolldown Module     ]]--

local _, BCM = ...
BCM.modules[#BCM.modules+1] = function()
	if bcmDB.BCM_ScrollDown or bcmDB.BCM_ButtonHide or not GetCVarBool("chatMouseScroll") then return end

	local scrollFunc = function(frame, d)
		if d then
			if d > 0 then
				if IsShiftKeyDown() then
					frame:ScrollToTop()
				elseif IsControlKeyDown() then
					frame:PageUp()
				--else -- Blizz function does this
				--	frame:ScrollUp()
				end
			elseif d < 0 then
				if IsShiftKeyDown() then
					frame:ScrollToBottom()
				elseif IsControlKeyDown() then
					frame:PageDown()
				--else -- Blizz function does this
				--	frame:ScrollDown()
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

	local clickFunc = function(frame) frame:GetParent():ScrollToBottom() frame:Hide() end
	for i=1, BCM.chatFrames do
		local btn = _G[format("%s%d%s", "ChatFrame", i, "ButtonFrameBottomButton")]
		btn:ClearAllPoints()
		local cf = btn:GetParent():GetParent()
		cf:HookScript("OnMouseWheel", scrollFunc)
		cf:HookScript("OnShow", scrollFunc)
		btn:SetParent(cf)
		btn:SetPoint("TOPRIGHT")
		btn:SetScript("OnClick", clickFunc)
		btn:SetSize(20, 20)
		btn:Hide()
	end
end

