
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
	if bcmDB.noconfig then
		makeButton, onShow, onClick = nil, nil, nil
		return
	end

	--[[ Slash handler ]]--
	SlashCmdList[name] = function() InterfaceOptionsFrame_OpenToCategory(name) end
	SLASH_BasicChatMods1 = "/bcm"

	--[[ Main Panel ]]--
	local bcm = CreateFrame("Frame", "BCM", InterfaceOptionsFramePanelContainer)
	bcm.name = name
	InterfaceOptions_AddCategory(bcm)
	local title = bcm:CreateFontString("BCM_Title", "ARTWORK", "GameFontNormal")
	title:SetPoint("TOPLEFT", 16, -16)
	title:SetText(">>ALL changes in this config require a /reload to take effect.<<\n\n\n\nAdd some useful text here, maybe about life and it's meaning,\n ..or maybe about BCM?\n\n\n\n42!!!!")

	--[[ Button Hide Module ]]--
	local buttons = CreateFrame("Frame", "BCM_ButtonHide", bcm)
	buttons.name, buttons.parent = "Button Hide", name
	local buttonsCheckbox = CreateFrame("CheckButton", nil, buttons)
	makeButton(buttonsCheckbox)
	buttonsCheckbox:SetPoint("TOPLEFT", 16, -25)

	local buttonsCheckboxText = buttons:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	buttonsCheckboxText:SetPoint("LEFT", buttonsCheckbox, "RIGHT", 0, 1)
	buttonsCheckboxText:SetText(ENABLE)
	InterfaceOptions_AddCategory(buttons)

	--[[ Channel Names Module ]]--
	local chanNames = CreateFrame("Frame", "BCM_ChannelNames", bcm)
	chanNames.name, chanNames.parent = "Channel Names", name
	local chanNamesCheckbox = CreateFrame("CheckButton", nil, chanNames)
	makeButton(chanNamesCheckbox)
	chanNamesCheckbox:SetPoint("TOPLEFT", 16, -25)

	local chanNamesCheckboxText = chanNames:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	chanNamesCheckboxText:SetPoint("LEFT", chanNamesCheckbox, "RIGHT", 0, 1)
	chanNamesCheckboxText:SetText(ENABLE)
	InterfaceOptions_AddCategory(chanNames)

	if not bcmDB.BCM_ChannelNames then
		--Delicious customizable channel names config loaded on demand
	end

	--[[ Chat Copy Module ]]--
	local copy = CreateFrame("Frame", "BCM_ChatCopy", bcm)
	copy.name, copy.parent = "Chat Copy", name
	local copyCheckbox = CreateFrame("CheckButton", nil, copy)
	makeButton(copyCheckbox)
	copyCheckbox:SetPoint("TOPLEFT", 16, -25)

	local copyCheckboxText = copy:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	copyCheckboxText:SetPoint("LEFT", copyCheckbox, "RIGHT", 0, 1)
	copyCheckboxText:SetText(ENABLE)
	InterfaceOptions_AddCategory(copy)

	--[[ Edit Box Module ]]--
	local edit = CreateFrame("Frame", "BCM_EditBox", bcm)
	edit.name, edit.parent = "Edit Box", name
	local editCheckbox = CreateFrame("CheckButton", nil, edit)
	makeButton(editCheckbox)
	editCheckbox:SetPoint("TOPLEFT", 16, -25)

	local editCheckboxText = edit:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	editCheckboxText:SetPoint("LEFT", editCheckbox, "RIGHT", 0, 1)
	editCheckboxText:SetText(ENABLE)
	InterfaceOptions_AddCategory(edit)

	--[[ Fade Module ]]--
	local fade = CreateFrame("Frame", "BCM_Fade", bcm)
	fade.name, fade.parent = "Fade", name
	local fadeCheckbox = CreateFrame("CheckButton", nil, fade)
	makeButton(fadeCheckbox)
	fadeCheckbox:SetPoint("TOPLEFT", 16, -25)

	local fadeCheckboxText = fade:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	fadeCheckboxText:SetPoint("LEFT", fadeCheckbox, "RIGHT", 0, 1)
	fadeCheckboxText:SetText(ENABLE)
	InterfaceOptions_AddCategory(fade)

	--[[ URLCopy Module ]]--
	local urls = CreateFrame("Frame", "BCM_URLCopy", bcm)
	urls.name, urls.parent = "URL Copy", name
	local urlsCheckbox = CreateFrame("CheckButton", nil, urls)
	makeButton(urlsCheckbox)
	urlsCheckbox:SetPoint("TOPLEFT", 16, -25)

	local urlsCheckboxText = urls:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	urlsCheckboxText:SetPoint("LEFT", urlsCheckbox, "RIGHT", 0, 1)
	urlsCheckboxText:SetText(ENABLE)
	InterfaceOptions_AddCategory(urls)

	makeButton = nil
end

