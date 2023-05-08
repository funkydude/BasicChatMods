
--[[     ChatCopy Module     ]]--

local _, BCM = ...
BCM.modules[#BCM.modules+1] = function()
	if bcmDB.BCM_ChatCopy then return end

	local BCMCopyFrame

	local scrollDown = function()
		BCMCopyFrame.scroll:SetVerticalScroll((BCMCopyFrame.scroll:GetVerticalScrollRange()) or 0)
	end

	--Copying Functions
	local copyFunc = function(frame)
		if not IsShiftKeyDown() then return end
		local cf = _G[format("%s%d", "ChatFrame", frame:GetID())]
		local text = ""
		for i = 1, cf:GetNumMessages() do
			local line = cf:GetMessageInfo(i)
			BCMCopyFrame.font:SetFormattedText("%s\n", line) -- We do this to fix special pipe methods e.g. 5 |4hour:hours; Example: copying /played text
			local cleanLine = BCMCopyFrame.font:GetText() or ""
			text = text .. cleanLine
		end
		text = text:gsub("|T[^\\]+\\[^\\]+\\[Uu][Ii]%-[Rr][Aa][Ii][Dd][Tt][Aa][Rr][Gg][Ee][Tt][Ii][Nn][Gg][Ii][Cc][Oo][Nn]_(%d)[^|]+|t", "{rt%1}") -- I like being able to copy raid icons
		text = text:gsub("|T13700([1-8])[^|]+|t", "{rt%1}") -- I like being able to copy raid icons
		text = text:gsub("|T[^|]+|t", "") -- Remove any other icons to prevent copying issues
		text = text:gsub("|K[^|]+|k", BCM.protectedText) -- Remove protected text
		BCMCopyFrame.box:SetText(text)
		BCMCopyFrame:Show()
		C_Timer.After(0, scrollDown) -- Scroll to the bottom, we have to delay it unfortunately
	end
	local tt = CreateFrame("GameTooltip", "BCMtooltip", UIParent, "GameTooltipTemplate")
	local hintFuncEnter = function(frame)
		if bcmDB.noChatCopyTip then return end

		tt:SetOwner(frame, "ANCHOR_TOP")
		tt:AddLine("|T135769:20|t"..BCM.CLICKTOCOPY, 1, 0, 0) -- Interface\\Icons\\Spell_ChargePositive
		tt:Show()
	end
	local hintFuncLeave = function()
		if bcmDB.noChatCopyTip then return end

		tt:Hide()
	end

	--Create Frames/Objects
	BCMCopyFrame = CreateFrame("Frame", nil, UIParent, "SettingsFrameTemplate")
	BCMCopyFrame:SetWidth(750)
	BCMCopyFrame:SetHeight(600)
	BCMCopyFrame:SetPoint("CENTER", UIParent, "CENTER")
	BCMCopyFrame:Hide()
	BCMCopyFrame:SetFrameStrata("DIALOG")
	BCMCopyFrame.NineSlice.Text:SetText("BasicChatMods")

	local scrollArea = CreateFrame("ScrollFrame", nil, BCMCopyFrame, "ScrollFrameTemplate")
	scrollArea:SetPoint("TOPLEFT", BCMCopyFrame, "TOPLEFT", 8, -30)
	scrollArea:SetPoint("BOTTOMRIGHT", BCMCopyFrame, "BOTTOMRIGHT", -25, 5)

	local editBox = CreateFrame("EditBox", nil, BCMCopyFrame)
	editBox:SetMultiLine(true)
	editBox:SetMaxLetters(0)
	editBox:EnableMouse(true)
	editBox:SetAutoFocus(false)
	editBox:SetFontObject(ChatFontNormal)
	editBox:SetWidth(720)
	editBox:SetHeight(595)
	editBox:SetScript("OnEscapePressed", function(f) f:GetParent():GetParent():Hide() f:SetText("") end)

	scrollArea:SetScrollChild(editBox)

	local font = BCMCopyFrame:CreateFontString(nil, nil, "GameFontNormal")
	font:Hide()

	BCMCopyFrame.font = font
	BCMCopyFrame.box = editBox
	BCMCopyFrame.scroll = scrollArea

	BCM.chatFuncsPerFrame[#BCM.chatFuncsPerFrame+1] = function(_, n)
		local tab = _G[n.."Tab"]
		tab:HookScript("OnClick", copyFunc)
		tab:HookScript("OnEnter", hintFuncEnter)
		tab:HookScript("OnLeave", hintFuncLeave)
	end
end

