
--[[     ChatCopy Module     ]]--

local _, BCM = ...
BCM.modules[#BCM.modules+1] = function()
	if bcmDB.BCM_ChatCopy then return end

	local scrollDown = function()
		BCMCopyScroll:SetVerticalScroll((BCMCopyScroll:GetVerticalScrollRange()) or 0)
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
		C_Timer.After(0.25, scrollDown) -- Scroll to the bottom, we have to delay it unfortunately
	end
	local tt = CreateFrame("GameTooltip", "BCMtooltip", UIParent, "GameTooltipTemplate")
	local hintFuncEnter = function(frame)
		if bcmDB.noChatCopyTip then return end

		tt:SetOwner(frame, "ANCHOR_TOP")
		tt:AddLine("|T135769:20|t"..BCM.CLICKTOCOPY, 1, 0, 0) -- Interface\\Icons\\Spell_ChargePositive
		tt:Show()
	end
	local hintFuncLeave = function(frame)
		if bcmDB.noChatCopyTip then return end

		tt:Hide()
	end

	--Create Frames/Objects
	local frame = CreateFrame("Frame", "BCMCopyFrame", UIParent, "BackdropTemplate")
	frame:SetBackdrop({bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
		tile = true, tileSize = 16, edgeSize = 16,
		insets = {left = 1, right = 1, top = 1, bottom = 1}}
	)
	frame:SetBackdropColor(0,0,0,1)
	frame:SetWidth(650)
	frame:SetHeight(500)
	frame:SetPoint("CENTER", UIParent, "CENTER")
	frame:Hide()
	frame:SetFrameStrata("DIALOG")

	local scrollArea = CreateFrame("ScrollFrame", "BCMCopyScroll", frame, "UIPanelScrollFrameTemplate")
	scrollArea:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, -5)
	scrollArea:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -30, 5)

	local editBox = CreateFrame("EditBox", nil, frame)
	editBox:SetMultiLine(true)
	editBox:SetMaxLetters(99999)
	editBox:EnableMouse(true)
	editBox:SetAutoFocus(false)
	editBox:SetFontObject(ChatFontNormal)
	editBox:SetWidth(620)
	editBox:SetHeight(495)
	editBox:SetScript("OnEscapePressed", function(f) f:GetParent():GetParent():Hide() f:SetText("") end)

	scrollArea:SetScrollChild(editBox)

	local close = CreateFrame("Button", "BCMCloseButton", frame, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, 25)

	local font = frame:CreateFontString(nil, nil, "GameFontNormal")
	font:Hide()

	BCMCopyFrame.font = font
	BCMCopyFrame.box = editBox

	BCM.chatFuncsPerFrame[#BCM.chatFuncsPerFrame+1] = function(_, n)
		local tab = _G[n.."Tab"]
		tab:HookScript("OnClick", copyFunc)
		tab:HookScript("OnEnter", hintFuncEnter)
		tab:HookScript("OnLeave", hintFuncLeave)
	end
end

