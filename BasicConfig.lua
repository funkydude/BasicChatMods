
local name, f = ...
local onClick = function(frame)
	local tick = frame:GetChecked()
	if tick then
		PlaySound("igMainMenuOptionCheckBoxOn")
		bcmDB[frame:GetParent():GetName()] = nil
	else
		PlaySound("igMainMenuOptionCheckBoxOff")
		bcmDB[frame:GetParent():GetName()] = true
	end
end
local onShow = function(frame)
	if bcmDB[frame:GetParent():GetName()] then
		frame:SetChecked(false)
	else
		frame:SetChecked(true)
	end
end
local makeButton = function(frame)
	--GlueXML/OptionsPanelTemplates.xml --> OptionsBaseCheckButtonTemplate
	frame:SetWidth(26)
	frame:SetHeight(26)
	frame:SetHitRectInsets(0, -100, 0, 0)
	frame:SetNormalTexture("Interface\\Buttons\\UI-CheckBox-Up")
	frame:SetPushedTexture("Interface\\Buttons\\UI-CheckBox-Down")
	frame:SetHighlightTexture("Interface\\Buttons\\UI-CheckBox-Highlight")
	frame:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")
	frame:SetDisabledCheckedTexture("Interface\Buttons\UI-CheckBox-Check-Disabled")
	frame:SetScript("OnClick", onClick)
	frame:SetScript("OnShow", onShow)
end
f.functions[#f.functions+1] = function()
	--[[ Slash handler ]]--
	SlashCmdList[name] = function() InterfaceOptionsFrame_OpenToCategory(name) end
	SLASH_BasicChatMods1 = "/bcm"

	--[[ Main Panel ]]--
	local bcm = CreateFrame("Frame", "BCM", InterfaceOptionsFramePanelContainer)
	bcm.name = name
	InterfaceOptions_AddCategory(bcm)
	local title = bcm:CreateFontString("BCM_Title", "ARTWORK", "GameFontNormal")
	title:SetPoint("TOPLEFT", 16, -16)
	title:SetText("A /reload is required for changes to take effect.\nAdd some useful text here, maybe about life and it's meaning, maybe about BCM.")

	--[[ Button Hide Module ]]--
	local buttons = CreateFrame("Frame", "BCM_ButtonHide", bcm)
	buttons.name, buttons.parent = "Button Hide", name
	local buttonsCheckbox = CreateFrame("CheckButton", nil, buttons, "OptionsBaseCheckButtonTemplate")
	makeButton(buttonsCheckbox)
	buttonsCheckbox:SetPoint("TOPLEFT", 16, -25)

	local buttonsCheckboxText = buttons:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	buttonsCheckboxText:SetPoint("LEFT", buttonsCheckbox, "RIGHT", 0, 1)
	buttonsCheckboxText:SetText(ENABLE)
	InterfaceOptions_AddCategory(buttons)


	makeButton = nil
end

