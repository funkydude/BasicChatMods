
--[[     ChatCopy Module     ]]--

local _, BCM = ...
BCM.modules[#BCM.modules+1] = function()
	if bcmDB.BCM_ChatCopy then return end

	--Copying Functions
	local copyFunc = function(frame)
		if not IsShiftKeyDown() then return end
		local cf = _G[format("%s%d", "ChatFrame", frame:GetID())]
		local text = ""
		for i = 1, cf:GetNumMessages() do
			text = text .. cf:GetMessageInfo(i) .. "\n"
		end
		text = text:gsub("|[Tt]Interface\\TargetingFrame\\UI%-RaidTargetingIcon_(%d):0|[Tt]", "{rt%1}") -- I like being able to copy raid icons
		text = text:gsub("|[Tt][^|]+|[Tt]", "") -- Remove any other icons to prevent copying issues
		BCMCopyBox:SetText(text)
		BCMCopyBox:HighlightText(0)
		BCMCopyFrame:Show()
		BCMCopyScroll.ScrollToBottom:Play() -- Scroll to the bottom, we have to delay it unfortunately
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

	-- XXX temp till 6.0
	local group = scrollArea:CreateAnimationGroup()
	local update = group:CreateAnimation()
	group:SetScript("OnFinished", function() BCMCopyScroll:SetVerticalScroll((BCMCopyScroll:GetVerticalScrollRange()) or 0) end)
	update:SetOrder(1)
	update:SetDuration(0.25)
	BCMCopyScroll.ScrollToBottom = group

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

	BCM.chatFuncsPerFrame[#BCM.chatFuncsPerFrame+1] = function(n)
		local tab = _G[n.."Tab"]
		tab:HookScript("OnClick", copyFunc)
		tab:HookScript("OnEnter", hintFunc)
	end
end

