
--[[		Settings		]]--

--TOP, BOTTOM, LEFT, RIGHT, BOTTOMLEFT, BOTTOMRIGHT, TOPLEFT, TOPRIGHT
local BUTTON_POSITION = "BOTTOMRIGHT"
--Try wowhead.com for spell icons
local BUTTON_ICON = "Spell_ChargePositive"


--[[		ChatCopy Module		]]--
local lines = {}
local frame = nil
local editBox = nil
local f = nil

local function createFrames()
	--[[		Create our frames on demand		]]--
	frame = CreateFrame("Frame", "BCMCopyFrame", UIParent)
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

	editBox = CreateFrame("EditBox", "BCMCopyBox", frame)
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

	f = true
end

local function GetLines(...)
	--[[		Grab all those lines		]]--
	local ct = 1
	for i = select("#", ...), 1, -1 do
		local region = select(i, ...)
		if region:GetObjectType() == "FontString" then
			lines[ct] = tostring(region:GetText())
			ct = ct + 1
		end
	end
	return ct - 1
end

local function Copy(cf)
	--[[		Stick all the grabbed text into our copying frame		]]--
	local _, size = cf:GetFont()
	FCF_SetChatWindowFontSize(cf, 0.01)
	local lineCt = GetLines(cf:GetRegions())
	local text = table.concat(lines, "\n", 1, lineCt)
	FCF_SetChatWindowFontSize(cf, size)
	if not f then createFrames() end
	frame:Show()
	editBox:SetText(text)
	editBox:HighlightText(0)
end

for i = 1, NUM_CHAT_WINDOWS do
	--[[		Create the magic button		]]--
	local cf = _G[format("ChatFrame%d",  i)]
	--Due to stacking ChatFrames, we have to make 7 buttons instead of 1 :/
	local button = CreateFrame("Button", format("BCMButtonCF%d", i), cf)
	button:SetPoint(BUTTON_POSITION)
	button:SetHeight(10) --LoadUp Height
	button:SetWidth(10) --LoadUp Width
	button:SetNormalTexture("Interface\\Icons\\"..BUTTON_ICON)
	button:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
	button:SetScript("OnClick", function() Copy(cf) end)
	button:SetScript("OnEnter", function()
		button:SetHeight(28) --Big Height
		button:SetWidth(28) --Big Width
		GameTooltip:SetOwner(button)
		GameTooltip:ClearLines()
		GameTooltip:AddLine("Click to copy text.")
		GameTooltip:Show()
	end)
	button:SetScript("OnLeave", function()
		button:SetHeight(10) --Small Height
		button:SetWidth(10) --Small Width
		GameTooltip:Hide()
	end)
	button:Hide()
	--[[		Show/Hide the button as needed		]]--
	local tab = _G[format("ChatFrame%dTab", i)]
	tab:SetScript("OnShow", function() button:Show() end)
	tab:SetScript("OnHide", function() button:Hide() end)
end
