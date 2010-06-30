
--[[		Settings		]]--

--TOP, BOTTOM, LEFT, RIGHT, BOTTOMLEFT, BOTTOMRIGHT, TOPLEFT, TOPRIGHT
local BUTTON_POSITION = "BOTTOMLEFT"
--Try wowhead.com for spell icons
local BUTTON_ICON = "Spell_ChargePositive"

--[[		ChatCopy Module		]]--
local lines = {}

local function createFrames()
	--[[		Create our frames on demand		]]--
	local frame = CreateFrame("Frame", "BCMCopyFrame", UIParent)
	frame:SetBackdrop({bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
		tile = true, tileSize = 16, edgeSize = 16,
		insets = {left = 3, right = 3, top = 5, bottom = 3}}
	)
	frame:SetBackdropColor(0,0,0,1)
	frame:SetWidth(500)
	frame:SetHeight(400)
	frame:SetPoint("CENTER", UIParent, "CENTER")
	frame:Hide()
	frame:SetFrameStrata("DIALOG")

	local scrollArea = CreateFrame("ScrollFrame", "BCMCopyScroll", frame, "UIPanelScrollFrameTemplate")
	scrollArea:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, -30)
	scrollArea:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -30, 8)

	local editBox = CreateFrame("EditBox", "BCMCopyBox", frame)
	editBox:SetMultiLine(true)
	editBox:SetMaxLetters(99999)
	editBox:EnableMouse(true)
	editBox:SetAutoFocus(false)
	editBox:SetFontObject(ChatFontNormal)
	editBox:SetWidth(400)
	editBox:SetHeight(270)
	editBox:SetScript("OnEscapePressed", function() frame:Hide() end)

	scrollArea:SetScrollChild(editBox)

	local close = CreateFrame("Button", "BCMCloseButton", frame, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", frame, "TOPRIGHT")
end

do
	local button = CreateFrame("Button", "BCMCopyChat")
	button:SetPoint(BUTTON_POSITION)
	button:SetHeight(10) --LoadUp Height
	button:SetWidth(10) --LoadUp Width
	button:SetNormalTexture("Interface\\Icons\\"..BUTTON_ICON)
	button:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
	button:SetScript("OnClick", function(frame)
		local cf = frame:GetParent()
		local _, size = cf:GetFont()
		FCF_SetChatWindowFontSize(cf, cf, 0.01)
		local ct = 1
		for i = select("#", cf:GetRegions()), 1, -1 do
			local region = select(i, cf:GetRegions())
			if region:GetObjectType() == "FontString" then
				lines[ct] = tostring(region:GetText())
				ct = ct + 1
			end
		end
		local lineCt = ct - 1
		local text = table.concat(lines, "\n", 1, lineCt)
		FCF_SetChatWindowFontSize(cf, cf, size)
		if not BCMCopyFrame then createFrames() end
		BCMCopyFrame:Show()
		BCMCopyBox:SetText(text)
		BCMCopyBox:HighlightText(0)
		wipe(lines)
	end)
	button:SetScript("OnEnter", function(frame)
		frame:SetHeight(28) --Big Height
		frame:SetWidth(28) --Big Width
		GameTooltip:SetOwner(frame)
		GameTooltip:ClearLines()
		GameTooltip:AddLine("Click to copy text.")
		GameTooltip:Show()
	end)
	button:SetScript("OnLeave", function(frame)
		frame:SetHeight(10) --Small Height
		frame:SetWidth(10) --Small Width
		GameTooltip:Hide()
	end)
	button:Hide()

	--[[		Show/Hide Copy Chat button on demand		]]--
	local t = 0
	local fadein = FCF_FadeInChatFrame
	FCF_FadeInChatFrame = function(frame)
		local time = GetTime()
		if time - t > 0.5 then
			--Stupid hack to make up for all docked chat frames being faded in
			--e.g. if you have 5 frames on 1 dock, this will trigger 5 times.
			BCMCopyChat:ClearAllPoints()
			BCMCopyChat:SetParent(frame)
			BCMCopyChat:SetPoint(BUTTON_POSITION, frame)
			BCMCopyChat:Show()
			t = time
		end
		return fadein(frame)
	end

	local fadeout = FCF_FadeOutChatFrame
	FCF_FadeOutChatFrame = function(frame)
		BCMCopyChat:Hide()
		fadeout(frame)
	end
end

