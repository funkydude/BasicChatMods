
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
			text = text .. cf:GetMessageInfo(i) .. "\n"
		end
		text = text:gsub("|[Tt]Interface\\TargetingFrame\\UI%-RaidTargetingIcon_(%d):0|[Tt]", "{rt%1}") -- I like being able to copy raid icons
		text = text:gsub("|[Tt]13700([1-8]):0|[Tt]", "{rt%1}") -- I like being able to copy raid icons
		text = text:gsub("|[Tt][^|]+|[Tt]", "") -- Remove any other icons to prevent copying issues
		BCMCopyFrame.font:SetText(text) -- We do this to fix special pipe methods e.g. 5 |4hour:hours; Example: copying /played text
		BCMCopyFrame.box:SetText(BCMCopyFrame.font:GetText())
		BCMCopyFrame:Show()
		C_Timer.After(0.25, scrollDown) -- Scroll to the bottom, we have to delay it unfortunately
	end
	local hintFunc = function(frame)
		if bcmDB.noChatCopyTip then return end

		if SHOW_NEWBIE_TIPS == "1" then
			GameTooltip:AddLine("\n|TInterface\\Icons\\Spell_ChargePositive:20|t"..BCM.CLICKTOCOPY, 1, 0, 0)
			GameTooltip:Show()
		else
			GameTooltip:SetOwner(frame, "ANCHOR_TOP")
			GameTooltip:AddLine("|TInterface\\Icons\\Spell_ChargePositive:20|t"..BCM.CLICKTOCOPY, 1, 0, 0)
			GameTooltip:Show()
		end
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

	BCM.chatFuncsPerFrame[#BCM.chatFuncsPerFrame+1] = function(n)
		local tab = _G[n.."Tab"]
		tab:HookScript("OnClick", copyFunc)
		tab:HookScript("OnEnter", hintFunc)
	end
end

