
local name, f = ...
f.functions[#f.functions+1] = function()
	if bcmDB.noconfig then
		return
	end

	local L = {}
	L.LEFT = "Left"
	L.RIGHT = "Right"
	L.CENTER = "Center"

	L.GENERAL = "General"
	L.TRADE = "Trade"
	L.WORLDDEFENSE = "WorldDefense"
	L.LOCALDEFENSE = "LocalDefense"
	L.LFG = "LookingForGroup"
	L.GUILDRECRUIT = "GuildRecruitment"

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

		--FrameXML/OptionsPanelTemplates.xml --> OptionsBaseCheckButtonTemplate
		local button = CreateFrame("CheckButton", nil, panel, "OptionsBaseCheckButtonTemplate")
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
		local chanName = "BCM_ChanName_Drop"
		local chan = CreateFrame("Frame", chanName, BCM_ChannelNames, "UIDropDownMenuTemplate")
		chan:SetPoint("TOPLEFT", 16, -120)
		chan:SetWidth(149) chan:SetHeight(32)
		_G[chanName.."Text"]:SetText(L.GENERAL)
		UIDropDownMenu_Initialize(chan, function()
			local selected, info = BCM_ChanName_DropText:GetText(), UIDropDownMenu_CreateInfo()
			info.func = function(v) BCM_ChanName_DropText:SetText(v:GetText())
			end
			local tbl = {L.GENERAL, L.TRADE, L.WORLDDEFENSE, L.LOCALDEFENSE, L.LFG, L.GUILDRECRUIT, BATTLEGROUND, BATTLEGROUND_LEADER, GUILD, PARTY, PARTY_LEADER, gsub(CHAT_PARTY_GUIDE_GET, ".*%[(.*)%].*", "%1"), OFFICER, RAID, RAID_LEADER, RAID_WARNING}
			for i=1, #tbl do
				info.text = tbl[i]
				info.value = i
				info.checked = info.text == selected
				UIDropDownMenu_AddButton(info)
			end
			wipe(tbl) tbl = nil
		end)
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
		--FrameXML/UIDropDownMenuTemplates.xml --> UIDropDownMenuTemplate
		local getName = "BCM_Justify_Get"
		local get = CreateFrame("Frame", getName, BCM_Justify, "UIDropDownMenuTemplate")
		get:SetPoint("TOPLEFT", 16, -120)
		get:SetWidth(149) get:SetHeight(32)
		_G[getName.."Text"]:SetText("ChatFrame1")
		UIDropDownMenu_Initialize(get, function()
			local selected, info = BCM_Justify_GetText:GetText(), UIDropDownMenu_CreateInfo()
			info.func = function(v) BCM_Justify_GetText:SetText(v.value)
				if bcmDB.justify and bcmDB.justify[v.value] then
					BCM_Justify_SetText:SetText(L[bcmDB.justify[v.value]])
				else
					BCM_Justify_SetText:SetText(L.LEFT)
				end
			end
			for i=1, 10 do
				info.text = ("ChatFrame%d"):format(i)
				info.value = info.text
				info.checked = info.text == selected
				UIDropDownMenu_AddButton(info)
			end
		end)

		local setName = "BCM_Justify_Set"
		local set = CreateFrame("Frame", setName, BCM_Justify, "UIDropDownMenuTemplate")
		set:SetPoint("LEFT", get, "RIGHT", 60, 0)
		set:SetWidth(125) set:SetHeight(32)
		if bcmDB.justify and bcmDB.justify[BCM_Justify_GetText:GetText()] then
			_G[setName.."Text"]:SetText(bcmDB.justify[BCM_Justify_GetText:GetText()])
		else
			_G[setName.."Text"]:SetText(L.LEFT)
		end
		UIDropDownMenu_Initialize(set, function()
			local selected, info = BCM_Justify_SetText:GetText(), UIDropDownMenu_CreateInfo()
			info.func = function(v) BCM_Justify_SetText:SetText(v:GetText())
				if not bcmDB.justify then bcmDB.justify = {} end
				if v.value == "RIGHT" or v.value == "CENTER" then
					bcmDB.justify[BCM_Justify_GetText:GetText()] = v.value
				else
					bcmDB.justify[BCM_Justify_GetText:GetText()] = nil
					--remove the table if we have no entries
					local w = nil
					for k in pairs(bcmDB.justify) do w = true end
					if not w then bcmDB.justify = nil end
				end
			end
			info.text = L.LEFT
			info.value = "LEFT"
			info.checked = info.text == selected
			UIDropDownMenu_AddButton(info)
			info.text = L.RIGHT
			info.value = "RIGHT"
			info.checked = info.text == selected
			UIDropDownMenu_AddButton(info)
			info.text = L.CENTER
			info.value = "CENTER"
			info.checked = info.text == selected
			UIDropDownMenu_AddButton(info)
		end)
	end

	--[[ Outline ]]--
	--makePanel("BCM_Outline", bcm, "Outline", "This module creates a small arrow over your chat frames that flashes if you're not at the very bottom.")

	--[[ Scroll Down ]]--
	makePanel("BCM_ScrollDown", bcm, "Scroll Down", "This module creates a small arrow over your chat frames that flashes if you're not at the very bottom.")

	--[[ Sticky ]]--
	makePanel("BCM_Sticky", bcm, "Sticky", "This module 'sticks' the last chat type you used so that you don't need to re-enter it again next time you chat.")

	if not bcmDB.BCM_Sticky then
		local stickyName = "BCM_Sticky_Drop"
		local sticky = CreateFrame("Frame", stickyName, BCM_Sticky, "UIDropDownMenuTemplate")
		sticky:SetPoint("TOPLEFT", 16, -120)
		sticky:SetWidth(149) sticky:SetHeight(32)
		_G[stickyName.."Text"]:SetText(SAY)
		UIDropDownMenu_Initialize(sticky, function()
			local selected, info = BCM_Sticky_DropText:GetText(), UIDropDownMenu_CreateInfo()
			info.func = function(v) BCM_Sticky_DropText:SetText(v:GetText())
				if ChatTypeInfo[v.value].sticky > 0 then
					BCM_Sticky_Button:SetChecked(true)
				else
					BCM_Sticky_Button:SetChecked(false)
				end
				BCM_Sticky_Button.value = v.value
			end
			local tbl = {"SAY", "PARTY", "RAID", "GUILD", "OFFICER", "YELL", "WHISPER", "EMOTE", "RAID_WARNING", "BATTLEGROUND", "CHANNEL"}
			for i=1, #tbl do
				info.text = _G[tbl[i]]
				info.value = tbl[i]
				info.checked = info.text == selected
				UIDropDownMenu_AddButton(info)
			end
			wipe(tbl) tbl = nil
		end)

		local stickyBtn = CreateFrame("CheckButton", "BCM_Sticky_Button", BCM_Sticky, "OptionsBaseCheckButtonTemplate")
		stickyBtn.value = "SAY"
		stickyBtn:SetScript("OnClick", function(frame)
			if frame:GetChecked() then
				PlaySound("igMainMenuOptionCheckBoxOn")
				ChatTypeInfo[frame.value].sticky = 1
				bcmDB.sticky[frame.value] = 1
			else
				PlaySound("igMainMenuOptionCheckBoxOff")
				ChatTypeInfo[frame.value].sticky = 0
				bcmDB.sticky[frame.value] = 0
			end
		end)
		stickyBtn:SetScript("OnShow", function(frame)
			if ChatTypeInfo[frame.value].sticky > 0 then
				frame:SetChecked(true)
			else
				frame:SetChecked(false)
			end
		end)
		stickyBtn:SetPoint("LEFT", sticky, "RIGHT", 60, 0)
		local stickyBtnText = BCM_Sticky:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		stickyBtnText:SetPoint("RIGHT", stickyBtn, "LEFT", 0, 1)
		stickyBtnText:SetText("Sticky")
	end

	--[[ URLCopy Module ]]--
	makePanel("BCM_URLCopy", bcm, "URL Copy", "This module turns websites in your chat frame into clickable links for you to copy. E.g. |cFFFFFFFF[www.battle.net]|r")

	makePanel = nil
end

