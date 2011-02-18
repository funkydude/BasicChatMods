
local name, f = ...
f.functions[#f.functions+1] = function()
	if bcmDB.noconfig then
		return
	end

--------------------------------------------------------------------------------
-- Localization
--

	local L = {}
	L.CORE = "Welcome to BasicChatMods, a simplistic approach to chat customization. Due to the way BCM is designed a /reload may be required for some changes.\n\nBy default BCM will allow you to drag your chat frames to the very edge of the screen, it will also allow you to resize your chat frames to any size you wish.\n\nThe remaining customization is done in BCM's modules which can be enabled or disabled at will."
	L.BCM_ButtonHide = "Completely hides the chat frame side buttons from view for the people that have no use for them."
	L.BCM_ChannelNames = "Selectively replace the channel names with custom names of your liking. E.g. [Party] >> [P]"
	L.BCM_ChatCopy = "This module allows you to copy chat directly from your chat frame by double-clicking the chat frame tab."
	L.BCM_EditBox = "This module simply moves the edit box (the box you type in) to the top of the chat frame, instead of the bottom."
	L.BCM_Fade = "Fade out the chat frames completely instead of partially when moving your mouse away from a chat frame."
	L.BCM_Justify = "Justify the text of the various chat frames to the right, left, or center of the chat frame."
	L.BCM_ScrollDown = "Create a small clickable arrow over your chat frames that flashes if you're not at the very bottom."
	L.BCM_Sticky = "Customize your 'sticky' chat. Makes the chat edit box remember the last chat type you used so that you don't need to re-enter it again next time you chat."
	L.BCM_URLCopy = "Turn websites in your chat frame into clickable links for you to easily copy. E.g. |cFFFFFFFF[www.battle.net]|r"
	L.BCM_TimestampCustomize = "Customize the Blizzard timestamps. You need to re-select the Blizzard timestamp each time you customize or disable this module."

	L.WARNING = "<<The changes you've made require a /reload to take effect>>"

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
		--Don't move things when opening the main BCM panel
		if BCM:IsShown() then return end

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
	local bcmTitle = bcm:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	bcmTitle:SetPoint("TOPLEFT", 16, -16)
	bcmTitle:SetText(name)
	local bcmDesc = bcm:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	bcmDesc:SetPoint("TOPLEFT", 16, -62)
	bcmDesc:SetText(L.CORE)
	bcmDesc:SetWidth(375)
	bcmDesc:SetJustifyH("CENTER")

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
	enableBtnText:SetPoint("LEFT", enableBtn, "RIGHT")
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
	--TODO convert this module into more than just outline: font/size/outline "Text Customize" module?
	--makePanel("BCM_Outline", bcm, "Outline")

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
		local stickyBtnText = stickyBtn:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		stickyBtnText:SetPoint("RIGHT", stickyBtn, "LEFT")
		stickyBtnText:SetText(GUILD_NEWS_MAKE_STICKY)
	end

	--[[ Timestamp Customize ]]--
	makePanel("BCM_TimestampCustomize", bcm, "Timestamp Customize")

	if not bcmDB.BCM_TimestampCustomize then
		local stampBtn = CreateFrame("CheckButton", "BCM_Timestamp_Button", BCM_TimestampCustomize, "OptionsBaseCheckButtonTemplate")
		stampBtn:SetScript("OnClick", function(frame)
			local input = BCM_ChanName_InputCol
			if frame:GetChecked() then
				PlaySound("igMainMenuOptionCheckBoxOn")
				bcmDB.stampcolor = "|cff777777"
				input:SetText("777777")
				input:EnableMouse(true)
			else
				PlaySound("igMainMenuOptionCheckBoxOff")
				bcmDB.stampcolor = ""
				input:SetText("")
				input:EnableMouse(false)
				input:ClearFocus()
			end
			TIMESTAMP_FORMAT_HHMM = "|r"..bcmDB.stampcolor..(bcmDB.stampbracket):format("%I:%M").."|r "
			TIMESTAMP_FORMAT_HHMM_24HR = "|r"..bcmDB.stampcolor..(bcmDB.stampbracket):format("%H:%M").."|r "
			TIMESTAMP_FORMAT_HHMM_AMPM = "|r"..bcmDB.stampcolor..(bcmDB.stampbracket):format("%I:%M %p").."|r "
			TIMESTAMP_FORMAT_HHMMSS = "|r"..bcmDB.stampcolor..(bcmDB.stampbracket):format("%I:%M:%S").."|r "
			TIMESTAMP_FORMAT_HHMMSS_24HR = "|r"..bcmDB.stampcolor..(bcmDB.stampbracket):format("%H:%M:%S").."|r "
			TIMESTAMP_FORMAT_HHMMSS_AMPM = "|r"..bcmDB.stampcolor..(bcmDB.stampbracket):format("%I:%M:%S %p").."|r "
		end)
		stampBtn:SetScript("OnShow", function(frame)
			local input = BCM_ChanName_InputCol
			input:SetText("123456")
			BCM_ChanName_InputBrack:SetText("1234567890")
			BCM_ChanName_InputBrack:SetText(bcmDB.stampbracket)
			if bcmDB.stampcolor == "" then
				frame:SetChecked(false)
				input:EnableMouse(false)
				input:SetText("")
				input:ClearFocus()
			else
				frame:SetChecked(true)
				input:SetText((bcmDB.stampcolor):sub(5))
			end
		end)
		stampBtn:SetPoint("TOPLEFT", 16, -140)
		stampBtn:SetHitRectInsets(0, -50, 0, 0)
		local stampBtnText = stampBtn:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		stampBtnText:SetPoint("LEFT", stampBtn, "RIGHT")
		stampBtnText:SetText(COLOR)

		local stampColInput = CreateFrame("EditBox", "BCM_ChanName_InputCol", BCM_TimestampCustomize, "InputBoxTemplate")
		stampColInput:SetPoint("LEFT", stampBtn, "RIGHT", 60, 0)
		stampColInput:SetAutoFocus(false)
		stampColInput:SetWidth(50)
		stampColInput:SetHeight(20)
		stampColInput:SetMaxLetters(6)
		stampColInput:SetScript("OnTextChanged", function(frame, changed)
			if changed then
				local txt = frame:GetText()
				if txt:find("%X") then frame:SetText((bcmDB.stampcolor):sub(5)) return end
				bcmDB.stampcolor = "|cff"..frame:GetText()
				TIMESTAMP_FORMAT_HHMM = "|r|cff"..txt..(bcmDB.stampbracket):format("%I:%M").."|r "
				TIMESTAMP_FORMAT_HHMM_24HR = "|r|cff"..txt..(bcmDB.stampbracket):format("%H:%M").."|r "
				TIMESTAMP_FORMAT_HHMM_AMPM = "|r|cff"..txt..(bcmDB.stampbracket):format("%I:%M %p").."|r "
				TIMESTAMP_FORMAT_HHMMSS = "|r|cff"..txt..(bcmDB.stampbracket):format("%I:%M:%S").."|r "
				TIMESTAMP_FORMAT_HHMMSS_24HR = "|r|cff"..txt..(bcmDB.stampbracket):format("%H:%M:%S").."|r "
				TIMESTAMP_FORMAT_HHMMSS_AMPM = "|r|cff"..txt..(bcmDB.stampbracket):format("%I:%M:%S %p").."|r "
			end
		end)
		local stampColInputText = stampColInput:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		stampColInputText:SetPoint("LEFT", stampColInput, "RIGHT", 10, 0)
		stampColInputText:SetText(">>>   http://bit.ly/bevPp")

		local stampBrackInput = CreateFrame("EditBox", "BCM_ChanName_InputBrack", BCM_TimestampCustomize, "InputBoxTemplate")
		stampBrackInput:SetPoint("TOP", stampColInput, "BOTTOM", 0, -20)
		stampBrackInput:SetAutoFocus(false)
		stampBrackInput:SetWidth(50)
		stampBrackInput:SetHeight(20)
		stampBrackInput:SetScript("OnTextChanged", function(frame, changed)
			if changed then
				local txt = frame:GetText()
				if not txt:find("%%s") then frame:SetText("[%s]") return end
				bcmDB.stampbracket = txt
				TIMESTAMP_FORMAT_HHMM = "|r"..bcmDB.stampcolor..(txt):format("%I:%M").."|r "
				TIMESTAMP_FORMAT_HHMM_24HR = "|r"..bcmDB.stampcolor..(txt):format("%H:%M").."|r "
				TIMESTAMP_FORMAT_HHMM_AMPM = "|r"..bcmDB.stampcolor..(txt):format("%I:%M %p").."|r "
				TIMESTAMP_FORMAT_HHMMSS = "|r"..bcmDB.stampcolor..(txt):format("%I:%M:%S").."|r "
				TIMESTAMP_FORMAT_HHMMSS_24HR = "|r"..bcmDB.stampcolor..(txt):format("%H:%M:%S").."|r "
				TIMESTAMP_FORMAT_HHMMSS_AMPM = "|r"..bcmDB.stampcolor..(txt):format("%I:%M:%S %p").."|r "
			end
		end)
		local stampBrackInputText = stampBrackInput:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		stampBrackInputText:SetPoint("LEFT", stampBrackInput, "RIGHT", 10, 0)
		stampBrackInputText:SetText(">>>   ".. DISPLAY_BORDERS .." (%s) / -%s- / %s ...")
	end

	--[[ URLCopy Module ]]--
	makePanel("BCM_URLCopy", bcm, "URL Copy")

	makePanel = nil
end

