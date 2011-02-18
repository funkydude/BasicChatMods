
local name, f = ...
f.functions[#f.functions+1] = function()
	if bcmDB.noconfig then
		return
	end

--------------------------------------------------------------------------------
-- Localization
--

	local L = {}
	L.BCM_ButtonHide = "This module will completely hide the chat frame side buttons. It gives the chat frame a much cleaner look."
	L.BCM_ChannelNames = "This module allows you to selectively replace the channel names with custom names of your liking."
	L.BCM_ChatCopy = "This module allows you to copy chat directly from your chat frame by simply double-clicking the chat frame tab."
	L.BCM_EditBox = "This module simply moves the edit box (the box you type in) to the top of the chat frame, instead of the bottom."
	L.BCM_Fade = "This module will fade out the chat frames completely instead of partially when moving your mouse away."
	L.BCM_Justify = "This module allows you to justify the text of the various chat frames to the right, left, or center."
	L.BCM_ScrollDown = "This module creates a small arrow over your chat frames that flashes if you're not at the very bottom."
	L.BCM_Sticky = "This module 'sticks' the last chat type you used so that you don't need to re-enter it again next time you chat."
	L.BCM_URLCopy = "This module turns websites in your chat frame into clickable links for you to copy. E.g. |cFFFFFFFF[www.battle.net]|r"
	L.BCM_TimestampCustomize = "Customize the Blizzard timestamps. You need to re-select the Blizzard timestamp each time you customize or disable this module."

	L.WARNING = "<<The change you've made requires a /reload to take effect.>>"

	L.LEFT = "Left"
	L.RIGHT = "Right"
	L.CENTER = "Center"

	L.GENERAL = "General"
	L.TRADE = "Trade"
	L.WORLDDEFENSE = "WorldDefense"
	L.LOCALDEFENSE = "LocalDefense"
	L.LFG = "LookingForGroup"
	L.GUILDRECRUIT = "GuildRecruitment"

	local GetL = GetLocale()
	if L == "deDE" then
		L.GENERAL = "Allgemein"
		L.TRADE = "Handel"
		L.WORLDDEFENSE = "Weltverteidigung"
		L.LOCALDEFENSE = "LokaleVerteidigung"
		L.LFG = "SucheNachGruppe"
		L.GUILDRECRUIT = "Gildenrekrutierung"
	elseif L == "ruRU" then
		L.GENERAL = "Общий"
		L.TRADE = "Торговля"
		L.WORLDDEFENSE = "Оборона: глобальный"
		L.LOCALDEFENSE = "Оборона"
		L.LFG = "Поиск спутников"
		L.GUILDRECRUIT = "Гильдии"
	end

--------------------------------------------------------------------------------
-- Core widgets/functions/etc
--

	local onShow = function(frame)
		local btn = BCMEnableButton
		btn:ClearAllPoints()
		btn:SetParent(frame)
		btn:SetPoint("TOPLEFT", 16, -100)

		local desc = BCMPanelDesc
		desc:ClearAllPoints()
		desc:SetParent(frame)
		desc:SetPoint("TOPLEFT", 16, -20)
		desc:SetText(L[frame:GetName()] or "test")

		local warn = BCM_Warning
		warn:ClearAllPoints()
		warn:SetParent(frame)
		warn:SetPoint("BOTTOMLEFT", 18, 20)
		if bcmDB[frame:GetName()] then
			btn:SetChecked(false)
		else
			btn:SetChecked(true)
		end
	end
	local makePanel = function(frameName, bcm, panelName, desc)
		local panel = CreateFrame("Frame", frameName, bcm)
		panel.name, panel.parent = panelName, name
		panel:SetScript("OnShow", onShow)
		InterfaceOptions_AddCategory(panel)
	end

	--[[ Slash handler ]]--
	SlashCmdList[name] = function() InterfaceOptionsFrame_OpenToCategory(name) end
	SLASH_BasicChatMods1 = "/bcm"

	--[[ Main Panel ]]--
	local bcm = CreateFrame("Frame", "BCM", InterfaceOptionsFramePanelContainer)
	bcm.name = name
	InterfaceOptions_AddCategory(bcm)

	--[[ FrameXML/OptionsPanelTemplates.xml --> OptionsBaseCheckButtonTemplate ]]--
	--[[ The main enable button, enable text, and panel description that all modules use, recycled ]]--
	local panelDesc = bcm:CreateFontString("BCMPanelDesc", "ARTWORK", "GameFontNormalLarge")
	panelDesc:SetWidth(350)
	panelDesc:SetWordWrap(true)
	local enableBtn = CreateFrame("CheckButton", "BCMEnableButton", BCM, "OptionsBaseCheckButtonTemplate")
	enableBtn:SetScript("OnClick", function(frame)
		BCM_Warning:Show()
		local tick = frame:GetChecked()
		if tick then
			PlaySound("igMainMenuOptionCheckBoxOn")
			bcmDB[frame:GetParent():GetName()] = nil
		else
			PlaySound("igMainMenuOptionCheckBoxOff")
			bcmDB[frame:GetParent():GetName()] = true
		end
	end)
	local enableBtnText = enableBtn:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	enableBtnText:SetPoint("LEFT", enableBtn, "RIGHT", 0, 1)
	enableBtnText:SetText(ENABLE)
	local warn = bcm:CreateFontString("BCM_Warning", "ARTWORK", "GameFontNormal")
	warn:SetJustifyH("CENTER")
	warn:SetText(L.WARNING)
	warn:Hide()


--------------------------------------------------------------------------------
-- Module Panel Creation
--

	--[[ Button Hide Module ]]--
	makePanel("BCM_ButtonHide", bcm, "Button Hide")

	--[[ Channel Names Module ]]--
	makePanel("BCM_ChannelNames", bcm, "Channel Names")

	if not bcmDB.BCM_ChannelNames then
		local chanName = "BCM_ChanName_Drop"
		local chan = CreateFrame("Frame", chanName, BCM_ChannelNames, "UIDropDownMenuTemplate")
		chan:SetPoint("TOPLEFT", 16, -140)
		chan:SetWidth(149) chan:SetHeight(32)
		_G[chanName.."Text"]:SetText(CHANNEL)
		UIDropDownMenu_Initialize(chan, function()
			local selected, info = BCM_ChanName_DropText:GetText(), UIDropDownMenu_CreateInfo()
			info.func = function(v) BCM_ChanName_DropText:SetText(v:GetText())
				local input = BCM_ChanName_Input
				input:EnableMouse(true)
				input:SetText("1234567890") --for some reason the text wont display without calling something long
				input:SetText(bcmDB.replacements[v.value])
				input.value = v.value
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

		local chanNameInput = CreateFrame("EditBox", "BCM_ChanName_Input", BCM_ChannelNames, "InputBoxTemplate")
		chanNameInput:SetPoint("LEFT", chan, "RIGHT", 60, 0)
		chanNameInput:SetAutoFocus(false)
		chanNameInput:SetWidth(100)
		chanNameInput:SetHeight(20)
		chanNameInput:SetJustifyH("CENTER")
		chanNameInput:SetMaxLetters(10)
		chanNameInput:EnableMouse(false)
		chanNameInput:SetScript("OnTextChanged", function(frame, changed)
			if changed then bcmDB.replacements[frame.value] = frame:GetText() end
		end)
	end

	--[[ Chat Copy Module ]]--
	makePanel("BCM_ChatCopy", bcm, "Chat Copy")

	--[[ Edit Box Module ]]--
	makePanel("BCM_EditBox", bcm, "Edit Box")

	--[[ Fade Module ]]--
	makePanel("BCM_Fade", bcm, "Fade")

	--[[ Justify Module ]]--
	makePanel("BCM_Justify", bcm, "Justify Text")

	if not bcmDB.BCM_Justify then
		--FrameXML/UIDropDownMenuTemplates.xml --> UIDropDownMenuTemplate
		local getName = "BCM_Justify_Get"
		local get = CreateFrame("Frame", getName, BCM_Justify, "UIDropDownMenuTemplate")
		get:SetPoint("TOPLEFT", 16, -140)
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
				_G[BCM_Justify_GetText:GetText()]:SetJustifyH(v.value)
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
	makePanel("BCM_ScrollDown", bcm, "Scroll Down")

	--[[ Sticky ]]--
	makePanel("BCM_Sticky", bcm, "Sticky")

	if not bcmDB.BCM_Sticky then
		local stickyName = "BCM_Sticky_Drop"
		local sticky = CreateFrame("Frame", stickyName, BCM_Sticky, "UIDropDownMenuTemplate")
		sticky:SetPoint("TOPLEFT", 16, -140)
		sticky:SetWidth(149) sticky:SetHeight(32)
		_G[stickyName.."Text"]:SetText(GUILD_NEWS_MAKE_STICKY)
		UIDropDownMenu_Initialize(sticky, function()
			local selected, info = BCM_Sticky_DropText:GetText(), UIDropDownMenu_CreateInfo()
			info.func = function(v) BCM_Sticky_DropText:SetText(v:GetText())
				local btn = BCM_Sticky_Button
				btn:Enable()
				if ChatTypeInfo[v.value].sticky > 0 then
					btn:SetChecked(true)
				else
					btn:SetChecked(false)
				end
				btn.value = v.value
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
		stickyBtn:Disable()
		stickyBtn:SetPoint("LEFT", sticky, "RIGHT", 140, 0)
		local stickyBtnText = BCM_Sticky:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		stickyBtnText:SetPoint("RIGHT", stickyBtn, "LEFT", 0, 1)
		stickyBtnText:SetText(GUILD_NEWS_MAKE_STICKY)
	end

	--[[ Timestamp Customize ]]--
	makePanel("BCM_TimestampCustomize", bcm, "Timestamp Customize")

	if not bcmDB.BCM_TimestampCustomize then
		
	end

	--[[ URLCopy Module ]]--
	makePanel("BCM_URLCopy", bcm, "URL Copy")

	makePanel = nil
end

