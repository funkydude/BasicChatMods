
--[[     Scrolldown Module     ]]--

local _, BCM = ...
BCM.modules[#BCM.modules+1] = function()
	if bcmDB.BCM_ScrollDown or bcmDB.BCM_ButtonHide or not GetCVarBool("chatMouseScroll") then return end

	local clickFunc = function(frame)
		frame:GetParent():ScrollToBottom()
		frame:Hide()
	end
	local scrollFunc = function(frame)
		local n = frame:GetName()
		if frame:AtBottom() then
			_G[n.."ButtonFrameBottomButton"]:Hide()
		else
			_G[n.."ButtonFrameBottomButton"]:Show()
		end
	end
	hooksecurefunc("FloatingChatFrame_OnMouseScroll", function(frame, d)
		if d == 1 then
			if IsShiftKeyDown() then
				frame:ScrollToTop()
			elseif IsControlKeyDown() then
				frame:PageUp()
			end
		else
			if IsShiftKeyDown() then
				frame:ScrollToBottom()
			elseif IsControlKeyDown() then
				frame:PageDown()
			end
		end
		scrollFunc(frame)
	end)

	-- Force our scroll hook to apply by making WoW re-apply the scrolling functionality
	InterfaceOptionsSocialPanelChatMouseScroll_SetScrolling("0")
	InterfaceOptionsSocialPanelChatMouseScroll_SetScrolling("1")

	BCM.chatFuncsPerFrame[#BCM.chatFuncsPerFrame+1] = function(n)
		local btn = _G[n.."ButtonFrameBottomButton"]
		btn:ClearAllPoints()
		local cf = _G[n]
		cf:HookScript("OnShow", scrollFunc)
		btn:SetParent(cf)
		btn:SetPoint("TOPRIGHT")
		btn:SetScript("OnClick", clickFunc)
		btn:SetSize(20, 20)
		btn:Hide()
	end
end

