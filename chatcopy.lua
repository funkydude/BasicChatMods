
--[[     ChatCopy Module     ]]--

local _, BCM = ...
BCM.modules[#BCM.modules+1] = function()
	if bcmDB.BCM_ChatCopy then return end

	local doubleclick = "Double-click to copy chat."
	local L = GetLocale()
	if L == "deDE" then
		doubleclick = "Double-click to copy chat."
	end

	--Copying Functions
	local copyFunc = function(frame, btn)
		local cf = _G[format("%s%d", "ChatFrame", frame:GetID())]
		local _, size = cf:GetFont()
		FCF_SetChatWindowFontSize(cf, cf, 0.01)
		local text = ""
		for i = select("#", cf:GetRegions()), 1, -1 do
			local region = select(i, cf:GetRegions())
			if region:GetObjectType() == "FontString" then
				text = text..region:GetText().."\n"
			end
		end
		FCF_SetChatWindowFontSize(cf, cf, size)
		BCMCopyFrame:Show()
		BCMCopyBox:SetText(text)
		BCMCopyBox:HighlightText(0)
	end
	local hintFunc = function(frame)
		if SHOW_NEWBIE_TIPS ~= "1" and bcmDB.noChatCopyTip then return end

		GameTooltip:SetOwner(frame, "ANCHOR_TOP")
		if SHOW_NEWBIE_TIPS == "1" then
			GameTooltip:AddLine(CHAT_OPTIONS_LABEL, 1, 1, 1)
			GameTooltip:AddLine(NEWBIE_TOOLTIP_CHATOPTIONS, nil, nil, nil, 1)
		end
		if not bcmDB.noChatCopyTip then
			GameTooltip:AddLine((SHOW_NEWBIE_TIPS == "1" and "\n" or "").."|TInterface\\Icons\\Spell_ChargePositive:20|t"..doubleclick, 1, 0, 0)
		end
		GameTooltip:Show()
	end

	--Create Frames/Objects
	local frame = CreateFrame("Frame", "BCMCopyFrame", UIParent)
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

	local editBox = CreateFrame("EditBox", "BCMCopyBox", frame)
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

	for i = 1, 10 do
		local tab = _G[format("%s%d%s", "ChatFrame", i, "Tab")]
		tab:SetScript("OnDoubleClick", copyFunc)
		tab:SetScript("OnEnter", hintFunc)
	end
end

