
local name, f = ...
f.functions[#f.functions+1] = function()
	if bcmDB.noconfig then
		return
	end

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
	local makePanel = function(frameName, bcm, panelName, desc)
		local panel = CreateFrame("Frame", frameName, bcm)
		panel.name, panel.parent = panelName, name
		local panelDesc = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
		panelDesc:SetPoint("TOPLEFT", 16, -20)
		panelDesc:SetText(desc)
		panelDesc:SetWidth(350)
		panelDesc:SetWordWrap(true)
		InterfaceOptions_AddCategory(panel)

		--GlueXML/OptionsPanelTemplates.xml --> OptionsBaseCheckButtonTemplate
		local button = CreateFrame("CheckButton", nil, panel)
		button:SetWidth(26)
		button:SetHeight(26)
		button:SetHitRectInsets(0, -100, 0, 0)
		button:SetNormalTexture("Interface\\Buttons\\UI-CheckBox-Up")
		button:SetPushedTexture("Interface\\Buttons\\UI-CheckBox-Down")
		button:SetHighlightTexture("Interface\\Buttons\\UI-CheckBox-Highlight")
		button:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")
		button:SetScript("OnClick", onClick)
		button:SetScript("OnShow", onShow)
		button:SetPoint("TOPLEFT", 16, -80)
		local buttonText = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		buttonText:SetPoint("LEFT", button, "RIGHT", 0, 1)
		buttonText:SetText(ENABLE)
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
	makePanel("BCM_ButtonHide", bcm, "Button Hide", "This module will completely hide the chat frame side buttons. It gives the chat frame a much cleaner look.")

	--[[ Channel Names Module ]]--
	makePanel("BCM_ChannelNames", bcm, "Channel Names", "This module allows you to selectively replace the channel names with custom names of your liking.")

	if not bcmDB.BCM_ChannelNames then
		--Delicious customizable channel names config loaded on demand
	end

	--[[ Chat Copy Module ]]--
	makePanel("BCM_ChatCopy", bcm, "Chat Copy", "This module allows you to copy chat directly from your chat frame by simply double-clicking the chat frame tab.")

	--[[ Edit Box Module ]]--
	makePanel("BCM_EditBox", bcm, "Edit Box", "This module simply moves the edit box (the box you type in) to the top of the chat frame, instead of the bottom.")

	--[[ Fade Module ]]--
	makePanel("BCM_Fade", bcm, "Fade", "This module will fade out the chat frames completely instead of partially when moving your mouse away.")

	--[[ Justify Module ]]--
	makePanel("BCM_Justify", bcm, "Justify Text", "This module allows you to justify the text of the various chat frames to the right, left, or center.")

	if not bcmDB.BCM_Justify then
		--create dropdown widgets here
	end

	--[[ URLCopy Module ]]--
	makePanel("BCM_URLCopy", bcm, "URL Copy", "This module turns websites in your chat frame into clickable links for you to copy. E.g. |cFFFFFFFF[www.battle.net]|r")

	makePanel = nil
end

