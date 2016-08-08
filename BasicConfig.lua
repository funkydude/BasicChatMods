
--[[     Basic Config Module     ]]--

local name, BCM = ...
BCM.modules[#BCM.modules+1] = function()
	if bcmDB.noconfig then return end

	--[[-------------------------------
	-- Core widgets/functions/etc
	-------------------------------]]--

	local onShow = function(frame)
		--Don't move recycled widgets when opening the main BCM panel
		if InterfaceOptionsFramePanelContainer.displayedPanel and InterfaceOptionsFramePanelContainer.displayedPanel.name == name then return end
		local panel = frame:GetName()

		local btn = BCMEnableButton
		btn:SetParent(frame)
		btn:SetPoint("TOPLEFT", 16, -100)

		local desc = BCMPanelDesc
		desc:SetParent(frame)
		desc:SetPoint("CENTER", frame, "TOP", 0, -30)
		desc:SetText(BCM[panel] or "No Description")

		local warn = BCM_Warning
		warn:SetParent(frame)
		warn:SetPoint("CENTER", 0, -200)
		if bcmDB[panel] then
			btn:SetChecked(false)
			local optionWarn = BCM_OptionsWarn
			optionWarn:SetParent(frame)
			optionWarn:SetPoint("CENTER")
			optionWarn:Show()
		else
			btn:SetChecked(true)
			BCM_OptionsWarn:Hide()
		end

		--[[ Modules ]]--
		if panel == "BCM_BNet" and BCM_BNetColor_Button then
			BCM_PlayerBrackDesc:SetParent(frame)
			BCM_PlayerBrackDesc:SetPoint("TOPLEFT", 16, -240)
			BCM_PlayerLBrack:SetParent(frame)
			BCM_PlayerLBrack:SetPoint("TOPLEFT", 32, -260)
			BCM_PlayerRBrack:SetParent(frame)
			BCM_PlayerRBrack:SetPoint("TOPLEFT", 64, -260)
			BCM_PlayerSeparator:SetParent(frame)
			BCM_PlayerSeparator:SetPoint("TOPLEFT", 96, -260)
			BCM_PlayerLBrack:SetText("1234567890")
			BCM_PlayerLBrack:SetText(bcmDB.playerLBrack)
			BCM_PlayerRBrack:SetText("1234567890")
			BCM_PlayerRBrack:SetText(bcmDB.playerRBrack)
			BCM_PlayerSeparator:SetText("1234567890")
			BCM_PlayerSeparator:SetText(bcmDB.playerSeparator)
		elseif panel == "BCM_ChannelNames" and BCM_ChanName_Input then
			BCM_ChanName_Input:SetText("1234567890")
			BCM_ChanName_Input:SetText(bcmDB.replacements[1])
		elseif panel == "BCM_PlayerNames" and BCM_PlayerLevel_Button then
			BCM_PlayerBrackDesc:SetParent(frame)
			BCM_PlayerBrackDesc:SetPoint("TOPLEFT", 16, -240)
			BCM_PlayerLBrack:SetParent(frame)
			BCM_PlayerLBrack:SetPoint("TOPLEFT", 32, -260)
			BCM_PlayerRBrack:SetParent(frame)
			BCM_PlayerRBrack:SetPoint("TOPLEFT", 64, -260)
			BCM_PlayerSeparator:SetParent(frame)
			BCM_PlayerSeparator:SetPoint("TOPLEFT", 96, -260)
			BCM_PlayerLBrack:SetText("1234567890")
			BCM_PlayerLBrack:SetText(bcmDB.playerLBrack)
			BCM_PlayerRBrack:SetText("1234567890")
			BCM_PlayerRBrack:SetText(bcmDB.playerRBrack)
			BCM_PlayerSeparator:SetText("1234567890")
			BCM_PlayerSeparator:SetText(bcmDB.playerSeparator)
		elseif panel == "BCM_Highlight" and BCM_Highlight_Input and bcmDB.highlightWord then
			BCM_Highlight_Input:SetText("1234567890")
			BCM_Highlight_Input:SetText(bcmDB.highlightWord)
		elseif panel == "BCM_Timestamp" and BCM_Timestamp_InputCol then
			BCM_Timestamp_InputCol:SetText("123456")
			BCM_Timestamp_Format:SetText("1234567890")
			BCM_Timestamp_Format:SetText(bcmDB.stampfmt)
			if bcmDB.stampcol == "" then
				BCM_TimestampColor_Button:SetChecked(false)
				BCM_Timestamp_InputCol:EnableMouse(false)
				BCM_Timestamp_InputCol:SetText("")
				BCM_Timestamp_InputCol:ClearFocus()
			else
				BCM_TimestampColor_Button:SetChecked(true)
				BCM_Timestamp_InputCol:SetText(bcmDB.stampcol)
			end
		end
	end
	local makePanel = function(frameName, bcm, panelName)
		local panel = CreateFrame("Frame", frameName, bcm)
		panel.name, panel.parent = panelName, name
		panel:SetScript("OnShow", onShow)
		InterfaceOptions_AddCategory(panel)
	end

	--[[ Slash handler ]]--
	SlashCmdList[name] = function() InterfaceOptionsFrame_OpenToCategory(name) InterfaceOptionsFrame_OpenToCategory(name) end
	SLASH_BasicChatMods1 = "/bcm"

	--[[ Main Panel ]]--
	local bcm = CreateFrame("Frame", "BCM", InterfaceOptionsFramePanelContainer)
	bcm.name = name
	InterfaceOptions_AddCategory(bcm)
	local bcmTitle = bcm:CreateFontString(nil, "ARTWORK", "GameFontNormalHuge")
	bcmTitle:SetPoint("CENTER", bcm, "TOP", 0, -30)
	bcmTitle:SetText(name.." @project-version@") --wowace magic, replaced with tag version
	local bcmDesc = bcm:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	bcmDesc:SetPoint("CENTER")
	bcmDesc:SetText(BCM.CORE)
	bcmDesc:SetWidth(450)
	bcmDesc:SetJustifyH("CENTER")

	--[[ The main enable button, enable text, and panel description that all modules use, recycled ]]--
	local panelDesc = bcm:CreateFontString("BCMPanelDesc", "ARTWORK", "GameFontNormalLarge")
	panelDesc:SetWidth(500)
	panelDesc:SetWordWrap(true)
	local enableBtn = CreateFrame("CheckButton", "BCMEnableButton", bcm, "OptionsBaseCheckButtonTemplate")
	enableBtn:SetScript("OnClick", function(frame)
		BCM_Warning:Show()
		if frame:GetChecked() then
			PlaySound("igMainMenuOptionCheckBoxOn")
			bcmDB[frame:GetParent():GetName()] = nil
		else
			PlaySound("igMainMenuOptionCheckBoxOff")
			bcmDB[frame:GetParent():GetName()] = true
		end
	end)
	local enableBtnText = enableBtn:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	enableBtnText:SetPoint("LEFT", enableBtn, "RIGHT")
	enableBtnText:SetText(ENABLE)
	local warn = bcm:CreateFontString("BCM_Warning", "ARTWORK", "GameFontNormal")
	warn:SetJustifyH("CENTER")
	warn:SetText(BCM.WARNING)
	warn:Hide()
	local optionsWarn = bcm:CreateFontString("BCM_OptionsWarn", "ARTWORK", "GameFontNormal")
	optionsWarn:SetJustifyH("CENTER")
	optionsWarn:SetText(BCM.OPTIONS)
	optionsWarn:Hide()
	BCM.info = {}

	--[[-------------------------------
	-- Module Panel Creation
	-------------------------------]]--

	--[[ Alt invite ]]--
	makePanel("BCM_AltInvite", bcm, "Alt Invite")

	--[[ Auto Log ]]--
	makePanel("BCM_AutoLog", bcm, "Auto Log")

	if not bcmDB.BCM_AutoLog then
		local onClick = function(frame)
			if frame:GetChecked() then
				PlaySound("igMainMenuOptionCheckBoxOn")
				if frame:GetName() == "BCM_ChatLog_Button" then
					bcmDB.logchat = true
					print("|cFF33FF99BasicChatMods|r: ", CHATLOGENABLED)
					LoggingChat(true)
				else
					BCM_Warning:Show()
					bcmDB.logcombat = true
				end
			else
				PlaySound("igMainMenuOptionCheckBoxOff")
				if frame:GetName() == "BCM_ChatLog_Button" then
					bcmDB.logchat = nil
					print("|cFF33FF99BasicChatMods|r: ", CHATLOGDISABLED)
					LoggingChat(false)
				else
					BCM_Warning:Show()
					bcmDB.logcombat = nil
				end
			end
		end

		local chatLogBtn = CreateFrame("CheckButton", "BCM_ChatLog_Button", BCM_AutoLog, "OptionsBaseCheckButtonTemplate")
		chatLogBtn:SetScript("OnClick", onClick)
		chatLogBtn:SetPoint("TOPLEFT", 16, -150)
		chatLogBtn:SetChecked(bcmDB.logchat)
		local chatLogBtnText = chatLogBtn:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		chatLogBtnText:SetPoint("LEFT", chatLogBtn, "RIGHT")
		chatLogBtnText:SetText(BCM.CHATLOG)

		local combatLogBtn = CreateFrame("CheckButton", "BCM_CombatLog_Button", BCM_AutoLog, "OptionsBaseCheckButtonTemplate")
		combatLogBtn:SetScript("OnClick", onClick)
		combatLogBtn:SetPoint("TOPLEFT", 16, -180)
		combatLogBtn:SetChecked(bcmDB.logcombat)
		local combatLogBtnText = combatLogBtn:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		combatLogBtnText:SetPoint("LEFT", combatLogBtn, "RIGHT")
		combatLogBtnText:SetText(BCM.COMBATLOG)
	end

	--[[ BattleNet ]]--
	makePanel("BCM_BNet", bcm, "BattleNet")

	if not bcmDB.BCM_BNet then
		local OnClick = function(frame)
			if frame:GetChecked() then
				PlaySound("igMainMenuOptionCheckBoxOn")
				if frame:GetName() == "BCM_BNetFakeName_Button" then
					bcmDB.noRealName = true
				elseif frame:GetName() == "BCM_BNetNoIcon_Button" then
					bcmDB.noBNetIcon = true
				else
					bcmDB.noBNetColor = nil
				end
			else
				PlaySound("igMainMenuOptionCheckBoxOff")
				if frame:GetName() == "BCM_BNetFakeName_Button" then
					bcmDB.noRealName = nil
				elseif frame:GetName() == "BCM_BNetNoIcon_Button" then
					bcmDB.noBNetIcon = nil
				else
					bcmDB.noBNetColor = true
				end
			end
		end

		local colorBtn = CreateFrame("CheckButton", "BCM_BNetColor_Button", BCM_BNet, "OptionsBaseCheckButtonTemplate")
		colorBtn:SetScript("OnClick", OnClick)
		colorBtn:SetPoint("TOPLEFT", 16, -140)
		colorBtn:SetChecked(not bcmDB.noBNetColor and true)
		local colorBtnText = colorBtn:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		colorBtnText:SetPoint("LEFT", colorBtn, "RIGHT")
		colorBtnText:SetText(CLASS_COLORS)
		local fakeNameBtn = CreateFrame("CheckButton", "BCM_BNetFakeName_Button", BCM_BNet, "OptionsBaseCheckButtonTemplate")
		fakeNameBtn:SetScript("OnClick", OnClick)
		fakeNameBtn:SetPoint("TOPLEFT", 16, -170)
		fakeNameBtn:SetChecked(bcmDB.noRealName)
		local fakeNameBtnText = fakeNameBtn:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		fakeNameBtnText:SetPoint("LEFT", fakeNameBtn, "RIGHT")
		fakeNameBtnText:SetText(BCM.FAKENAMES)
		local removeIconBtn = CreateFrame("CheckButton", "BCM_BNetNoIcon_Button", BCM_BNet, "OptionsBaseCheckButtonTemplate")
		removeIconBtn:SetScript("OnClick", OnClick)
		removeIconBtn:SetPoint("TOPLEFT", 16, -200)
		removeIconBtn:SetChecked(bcmDB.noBNetIcon)
		local removeIconBtnText = removeIconBtn:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		removeIconBtnText:SetPoint("LEFT", removeIconBtn, "RIGHT")
		removeIconBtnText:SetText(BCM.BNETICON:format("|TInterface\\FriendsFrame\\UI-Toast-ToastIcons.tga:16:16:0:0:128:64:2:29:34:61|t"))

		local brackInputText = BCM_BNet:CreateFontString("BCM_PlayerBrackDesc", "ARTWORK", "GameFontNormal")
		brackInputText:SetPoint("TOPLEFT", 16, -240)
		brackInputText:SetText(BCM.PLAYERBRACKETS)
		local brackLInput = CreateFrame("EditBox", "BCM_PlayerLBrack", BCM_BNet, "InputBoxTemplate")
		brackLInput:SetPoint("TOPLEFT", 32, -260)
		brackLInput:SetAutoFocus(false)
		brackLInput:SetWidth(20)
		brackLInput:SetHeight(20)
		brackLInput:SetJustifyH("CENTER")
		brackLInput:SetScript("OnTextChanged", function(frame, changed)
			if changed then bcmDB.playerLBrack = frame:GetText() end
		end)
		brackLInput:SetScript("OnEnterPressed", brackLInput:GetScript("OnEscapePressed"))
		local brackRInput = CreateFrame("EditBox", "BCM_PlayerRBrack", BCM_BNet, "InputBoxTemplate")
		brackRInput:SetPoint("TOPLEFT", 64, -260)
		brackRInput:SetAutoFocus(false)
		brackRInput:SetWidth(20)
		brackRInput:SetHeight(20)
		brackRInput:SetJustifyH("CENTER")
		brackRInput:SetScript("OnTextChanged", function(frame, changed)
			if changed then bcmDB.playerRBrack = frame:GetText() end
		end)
		brackRInput:SetScript("OnEnterPressed", brackRInput:GetScript("OnEscapePressed"))
		local separatorInput = CreateFrame("EditBox", "BCM_PlayerSeparator", BCM_BNet, "InputBoxTemplate")
		separatorInput:SetPoint("TOPLEFT", 96, -260)
		separatorInput:SetAutoFocus(false)
		separatorInput:SetWidth(20)
		separatorInput:SetHeight(20)
		separatorInput:SetJustifyH("CENTER")
		separatorInput:SetScript("OnTextChanged", function(frame, changed)
			if changed then bcmDB.playerSeparator = frame:GetText() end
		end)
		separatorInput:SetScript("OnEnterPressed", separatorInput:GetScript("OnEscapePressed"))
	end

	--[[ Button Hide ]]--
	makePanel("BCM_ButtonHide", bcm, "Button Hide")

	--[[ Channel Names ]]--
	makePanel("BCM_ChannelNames", bcm, "Channel Names")

	if not bcmDB.BCM_ChannelNames then
		local channelTip = BCM_ChannelNames:CreateFontString("BCM_ChanName_Tip", "ARTWORK", "GameFontHighlight")
		channelTip:SetPoint("TOPLEFT", 210, -170)
		channelTip:SetText("%1 == ".. BCM.CHANNELNUMBER.. "\n%2 == ".. BCM.CHANNELNAME)
		channelTip:Hide()
		local chan = CreateFrame("Frame", "BCM_ChanName_Drop", BCM_ChannelNames, "UIDropDownMenuTemplate")
		chan:SetPoint("TOPLEFT", 16, -140)
		BCM_ChanName_DropMiddle:SetWidth(130)
		BCM_ChanName_DropText:SetText(ADD_CHANNEL)
		chan.initialize = function()
			local selected, info = BCM_ChanName_DropText:GetText(), wipe(BCM.info)
			info.func = function(v) BCM_ChanName_DropText:SetText(v:GetText())
				if v:GetText() == BCM.CUSTOMCHANNEL then BCM_ChanName_Tip:Show() else BCM_ChanName_Tip:Hide() end
				local input = BCM_ChanName_Input
				input:EnableMouse(true)
				input:SetText("1234567890") --for some reason the text wont display without calling something long
				input:SetText(bcmDB.replacements[v.value])
				input.value = v.value
			end
			local tbl = {BCM.GENERAL, BCM.TRADE, BCM.WORLDDEFENSE, BCM.LOCALDEFENSE, BCM.LFG, BCM.GUILDRECRUIT, INSTANCE_CHAT, INSTANCE_CHAT_LEADER, GUILD, PARTY, PARTY_LEADER, gsub(CHAT_PARTY_GUIDE_GET, ".*%[(.*)%].*", "%1"), OFFICER, RAID, RAID_LEADER, RAID_WARNING, BCM.CUSTOMCHANNEL}
			for i=1, #tbl do
				info.text = tbl[i]
				info.value = i
				info.checked = info.text == selected
				UIDropDownMenu_AddButton(info)
				tbl[i] = nil
			end
			tbl = nil
		end

		local chanNameInput = CreateFrame("EditBox", "BCM_ChanName_Input", BCM_ChannelNames, "InputBoxTemplate")
		chanNameInput:SetPoint("LEFT", chan, "RIGHT", 170, 0)
		chanNameInput:SetAutoFocus(false)
		chanNameInput:SetWidth(100)
		chanNameInput:SetHeight(20)
		chanNameInput:SetJustifyH("CENTER")
		chanNameInput:SetMaxLetters(10)
		chanNameInput:EnableMouse(false)
		chanNameInput:SetScript("OnTextChanged", function(frame, changed)
			if changed then bcmDB.replacements[frame.value] = frame:GetText() end
		end)
		chanNameInput:SetScript("OnEnterPressed", chanNameInput:GetScript("OnEscapePressed"))
	end

	--[[ Chat Copy ]]--
	makePanel("BCM_ChatCopy", bcm, "Chat Copy")

	if not bcmDB.BCM_ChatCopy then
		local chatCopyBtn = CreateFrame("CheckButton", "BCM_ChatCopy_Button", BCM_ChatCopy, "OptionsBaseCheckButtonTemplate")
		chatCopyBtn:SetScript("OnClick", function(frame)
			if frame:GetChecked() then
				PlaySound("igMainMenuOptionCheckBoxOn")
				bcmDB.noChatCopyTip = nil
			else
				PlaySound("igMainMenuOptionCheckBoxOff")
				bcmDB.noChatCopyTip = true
			end
		end)
		chatCopyBtn:SetPoint("TOPLEFT", 16, -150)
		chatCopyBtn:SetChecked(not bcmDB.noChatCopyTip and true)
		local chatCopyBtnText = chatCopyBtn:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		chatCopyBtnText:SetPoint("LEFT", chatCopyBtn, "RIGHT")
		chatCopyBtnText:SetText(SHOW_NEWBIE_TIPS_TEXT)
	end

	--[[ Edit Box ]]--
	makePanel("BCM_EditBox", bcm, "Edit Box")

	if not bcmDB.BCM_EditBox then
		local editBoxBGBtn = CreateFrame("CheckButton", "BCM_EditBoxBG_Button", BCM_EditBox, "OptionsBaseCheckButtonTemplate")
		editBoxBGBtn:SetScript("OnClick", function(frame)
			if frame:GetChecked() then
				PlaySound("igMainMenuOptionCheckBoxOn")
				bcmDB.noEditBoxBG = true
				for i=1, BCM.chatFrames do
					local eb = format("%s%d%s", "ChatFrame", i, "EditBox")
					_G[eb.."Left"]:Hide()
					_G[eb.."Mid"]:Hide()
					_G[eb.."Right"]:Hide()
				end
			else
				PlaySound("igMainMenuOptionCheckBoxOff")
				bcmDB.noEditBoxBG = nil
				for i=1, BCM.chatFrames do
					local eb = format("%s%d%s", "ChatFrame", i, "EditBox")
					_G[eb.."Left"]:Show()
					_G[eb.."Mid"]:Show()
					_G[eb.."Right"]:Show()
				end
			end
		end)
		editBoxBGBtn:SetPoint("TOPLEFT", 16, -150)
		editBoxBGBtn:SetChecked(bcmDB.noEditBoxBG)
		local editBoxBGBtnText = editBoxBGBtn:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		editBoxBGBtnText:SetPoint("LEFT", editBoxBGBtn, "RIGHT")
		editBoxBGBtnText:SetText(HIDE_PULLOUT_BG)

		local editBoxSlider = CreateFrame("Slider", "BCM_EditBoxScale_Slider", BCM_EditBox, "OptionsSliderTemplate")
		editBoxSlider:SetMinMaxValues(0.5, 2)
		editBoxSlider:SetValue(bcmDB.editBoxScale or 1)
		editBoxSlider:SetValueStep(0.1)
		editBoxSlider:SetScript("OnValueChanged", function(_, v)
			BCM_EditBoxScale_SliderText:SetFormattedText("%s %.1f", BCM.SIZE, v)
			if v == 1 then bcmDB.editBoxScale = nil else bcmDB.editBoxScale = v end
			for i=1, BCM.chatFrames do _G[format("%s%d%s", "ChatFrame", i, "EditBox")]:SetScale(v) end
		end)
		BCM_EditBoxScale_SliderHigh:SetText(2)
		BCM_EditBoxScale_SliderLow:SetText(0.5)
		BCM_EditBoxScale_SliderText:SetFormattedText("%s %.1f", BCM.SIZE, bcmDB.editBoxScale or 1)
		editBoxSlider:SetPoint("TOPLEFT", 20, -200)

		local editBoxPosition = CreateFrame("Frame", "BCM_EditBoxPosition", BCM_EditBox, "UIDropDownMenuTemplate")
		editBoxPosition:SetPoint("TOPLEFT", -5, -250)
		BCM_EditBoxPositionMiddle:SetWidth(100)
		BCM_EditBoxPositionText:SetText(bcmDB.editBoxOnBottom and BCM.BOTTOM or BCM.TOP)
		editBoxPosition.initialize = function()
			local selected, info = BCM_EditBoxPositionText:GetText(), wipe(BCM.info)
			info.func = function(v) BCM_EditBoxPositionText:SetText(v:GetText())
				if v.value == "BOTTOM" then
					bcmDB.editBoxOnBottom = true
					for i=1, BCM.chatFrames do
						local cf = _G[("ChatFrame%d"):format(i)]
						local eb = _G[("ChatFrame%dEditBox"):format(i)]
						eb:ClearAllPoints()
						eb:SetPoint("TOPLEFT", cf, "BOTTOMLEFT", -5, -2.0000002384186)
						eb:SetPoint("TOPRIGHT", cf, "BOTTOMRIGHT", 5, -2.0000002384186)
					end
				else
					bcmDB.editBoxOnBottom = nil
					for i=1, BCM.chatFrames do
						local cf = _G[("ChatFrame%d"):format(i)]
						local eb = _G[("ChatFrame%dEditBox"):format(i)]
						eb:ClearAllPoints()
						eb:SetPoint("BOTTOMLEFT", cf, "TOPLEFT", -5, -2.0000002384186)
						eb:SetPoint("BOTTOMRIGHT", cf, "TOPRIGHT", 5, -2.0000002384186)
					end
				end
			end
			info.text = BCM.TOP
			info.value = "TOP"
			info.checked = info.text == selected
			UIDropDownMenu_AddButton(info)

			info.text = BCM.BOTTOM
			info.value = "BOTTOM"
			info.checked = info.text == selected
			UIDropDownMenu_AddButton(info)
		end
	end

	--[[ Fade ]]--
	makePanel("BCM_Fade", bcm, "Fade")

	--[[ Font ]]--
	makePanel("BCM_Font", bcm, "Font")

	if not bcmDB.BCM_Font then
		local fontName = CreateFrame("Frame", "BCM_FontName", BCM_Font, "UIDropDownMenuTemplate")
		fontName:SetPoint("TOPLEFT", -5, -140)
		BCM_FontNameMiddle:SetWidth(100)
		BCM_FontNameText:SetText("Font")
		fontName.initialize = function()
			local selected, info = BCM_FontNameText:GetText(), wipe(BCM.info)
			info.func = function(v) BCM_FontNameText:SetText(v:GetText())
				bcmDB.fontname = v.value
				for i=1, BCM.chatFrames do
					local cF = _G[format("%s%d", "ChatFrame", i)]
					local cFE = _G[format("%s%d%s", "ChatFrame", i, "EditBox")]
					local _, size = cF:GetFont()
					cF:SetFont(v.value, bcmDB.fontsize or size, bcmDB.fontflag)
					cFE:SetFont(v.value, bcmDB.fontsize or size, bcmDB.fontflag)
				end
			end
			local lsm = LibStub and LibStub("LibSharedMedia-3.0", true)
			if lsm then
				local tbl = lsm:List("font")
				for i=1, #tbl do
					info.text = tbl[i]
					info.value = lsm:Fetch("font", tbl[i])
					info.checked = info.text == selected
					UIDropDownMenu_AddButton(info)
				end
			else
				local tbl
				local myLocale = GetLocale()
				if myLocale == "ruRU" then
					tbl = {["Arial Narrow"] = "Fonts\\ARIALN.TTF", ["Friz Quadrata"] = "Fonts\\FRIZQT__.TTF", ["Morpheus"] = "Fonts\\MORPHEUS.TTF", ["Nimrod MT"] = "Fonts\\NIM_____.ttf", ["Skurri"] = "Fonts\\SKURRI.TTF"}
				elseif myLocale == "koKR" then
					tbl = {["굵은 글꼴"] = "Fonts\\2002B.TTF", ["기본 글꼴"] = "Fonts\\2002.TTF", ["데미지 글꼴"] = "Fonts\\K_Damage.TTF", ["퀘스트 글꼴"] = "Fonts\\K_Pagetext.TTF"}
				elseif myLocale == "zhTW" then
					tbl = {["提示訊息"] = "Fonts\\bHEI00M.ttf", ["聊天"] = "Fonts\\bHEI01B.ttf", ["傷害數字"] = "Fonts\\bKAI00M.ttf", ["預設"] = "Fonts\\bLEI00D.ttf"}
				elseif myLocale == "zhCN" then
					tbl = {["伤害数字"] = "Fonts\\ARKai_C.ttf", ["默认"] = "Fonts\\ARKai_T.ttf", ["聊天"] = "Fonts\\ARHei.ttf"}
				else
					tbl = {["Arial Narrow"] = "Fonts\\ARIALN.TTF", ["Friz Quadrata"] = "Fonts\\FRIZQT__.TTF", ["Morpheus"] = "Fonts\\MORPHEUS.TTF", ["Skurri"] = "Fonts\\SKURRI.TTF"}
				end
				for k,v in pairs(tbl) do
					info.text = k
					info.value = v
					info.checked = info.text == selected
					UIDropDownMenu_AddButton(info)
					tbl[k] = nil
				end
				tbl = nil
			end
		end

		local fontSizeSlider = CreateFrame("Slider", "BCM_FontSize", BCM_Font, "OptionsSliderTemplate")
		fontSizeSlider:SetMinMaxValues(6, 20)
		fontSizeSlider:SetValue(bcmDB.fontsize or select(2, ChatFrame1:GetFont()))
		fontSizeSlider:SetValueStep(1)
		fontSizeSlider:SetWidth(110)
		fontSizeSlider:SetScript("OnValueChanged", function(_, v)
			BCM_FontSizeText:SetFormattedText(FONT_SIZE.." "..FONT_SIZE_TEMPLATE, v)
			bcmDB.fontsize = v
			for i=1, BCM.chatFrames do
				local cF = _G[format("%s%d", "ChatFrame", i)]
				local cFE = _G[format("%s%d%s", "ChatFrame", i, "EditBox")]
				local fName = cF:GetFont()
				cF:SetFont(bcmDB.fontname or fName, v, bcmDB.fontflag)
				cFE:SetFont(bcmDB.fontname or fName, v, bcmDB.fontflag)
			end
		end)
		BCM_FontSizeHigh:SetText(20)
		BCM_FontSizeLow:SetText(6)
		BCM_FontSizeText:SetFormattedText(FONT_SIZE.." "..FONT_SIZE_TEMPLATE, bcmDB.fontsize or select(2, ChatFrame1:GetFont()))
		fontSizeSlider:SetPoint("LEFT", fontName, "RIGHT", 120, 0)

		local fontFlag = CreateFrame("Frame", "BCM_FontFlag", BCM_Font, "UIDropDownMenuTemplate")
		fontFlag:SetPoint("LEFT", fontSizeSlider, "RIGHT", 5, 0)
		BCM_FontFlagMiddle:SetWidth(100)
		BCM_FontFlagText:SetText(NONE)
		fontFlag.initialize = function()
			local selected, info = BCM_FontFlagText:GetText(), wipe(BCM.info)
			info.func = function(v) BCM_FontFlagText:SetText(v:GetText())
				if v.value == NONE then 
					bcmDB.fontflag = nil
				else
					bcmDB.fontflag = v.value
				end
				for i=1, BCM.chatFrames do
					local cF = _G[format("%s%d", "ChatFrame", i)]
					local cFE = _G[format("%s%d%s", "ChatFrame", i, "EditBox")]
					local fName, size = cF:GetFont()
					cF:SetFont(bcmDB.fontname or fName, bcmDB.fontsize or size, bcmDB.fontflag)
					cFE:SetFont(bcmDB.fontname or fName, bcmDB.fontsize or size, bcmDB.fontflag)
				end
			end
			local tbl = {NONE, "OUTLINE", "THICKOUTLINE", "MONOCHROME"}
			for i=1, #tbl do
				info.text = tbl[i]
				info.checked = info.text == selected
				UIDropDownMenu_AddButton(info)
				tbl[i] = nil
			end
			tbl = nil
		end
	end

	--[[ GMOTD ]]--
	makePanel("BCM_GMOTD", bcm, "GMOTD")

	--[[ Highlight ]]--
	makePanel("BCM_Highlight", bcm, "Highlight")

	if not bcmDB.BCM_Highlight then
		local secondaryNameDesc = BCM_Highlight:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
		secondaryNameDesc:SetPoint("TOPLEFT", 20, -150)
		secondaryNameDesc:SetText("Secondary Name:")
		local secondaryNameInput = CreateFrame("EditBox", "BCM_Highlight_Input", BCM_Highlight, "InputBoxTemplate")
		secondaryNameInput:SetPoint("TOPLEFT", 25, -165)
		secondaryNameInput:SetAutoFocus(false)
		secondaryNameInput:SetWidth(100)
		secondaryNameInput:SetHeight(20)
		secondaryNameInput:SetScript("OnTextChanged", function(frame, changed)
			if changed then
				local t = frame:GetText()
				if t:find("[%(%)%.%%%+%-%*%?%[%^%$%]!\"£&_={}@'~#:;/\\<>,|`¬%d]") then frame:SetText(bcmDB.highlightWord or "") return end
				t = (t):lower()
				frame:SetText(t)
				if strlen(t) > 2 then
					bcmDB.highlightWord = t
				else
					bcmDB.highlightWord = nil
				end
				BCM_Warning:Show()
			end
		end)
		secondaryNameInput:SetScript("OnEnterPressed", secondaryNameInput:GetScript("OnEscapePressed"))
	end

	--[[ History ]]--
	makePanel("BCM_History", bcm, "History")

	if not bcmDB.BCM_History then
		local chatFrameSlider = CreateFrame("Slider", "BCM_History_Get", BCM_History, "OptionsSliderTemplate")
		chatFrameSlider:SetMinMaxValues(1, 10)
		chatFrameSlider:SetValue(1)
		chatFrameSlider:SetValueStep(1)
		chatFrameSlider:SetScript("OnValueChanged", function(_, v)
			local cF = ("ChatFrame%d"):format(v)
			BCM_History_GetText:SetFormattedText("%s: %s", cF, _G[cF].name)
			BCM_History_Set:SetValue(bcmDB.lines and bcmDB.lines[cF] or _G[cF]:GetMaxLines())
			BCM_History_SetText:SetFormattedText("%s: %d", HISTORY, bcmDB.lines and bcmDB.lines[cF] or _G[cF]:GetMaxLines())
		end)
		BCM_History_GetHigh:SetText(10)
		BCM_History_GetLow:SetText(1)
		BCM_History_GetText:SetFormattedText("ChatFrame1: %s", ChatFrame1.name)
		chatFrameSlider:SetPoint("TOPLEFT", 16, -160)

		local linesSetSlider = CreateFrame("Slider", "BCM_History_Set", BCM_History, "OptionsSliderTemplate")
		linesSetSlider:SetMinMaxValues(10, 2500)
		linesSetSlider:SetValue(bcmDB.lines and bcmDB.lines.ChatFrame1 or ChatFrame1:GetMaxLines())
		linesSetSlider:SetValueStep(10)
		linesSetSlider:SetWidth(200)
		linesSetSlider:SetScript("OnValueChanged", function(_, v)
			BCM_History_SetText:SetFormattedText("%s: %d", HISTORY, v)
			local cF = ("ChatFrame%d"):format(BCM_History_Get:GetValue())
			if v == _G[cF]:GetMaxLines() then return end -- No value changed, don't save anything
			bcmDB.lines[cF] = v
			_G[cF]:SetMaxLines(v)
			if cF == "ChatFrame2" then
				COMBATLOG_MESSAGE_LIMIT = v -- Blizzard keeps changing the combat log max lines in Blizzard_CombatLog_Refilter... this better not taint.
			end
		end)
		BCM_History_SetHigh:SetText(2500)
		BCM_History_SetLow:SetText(10)
		BCM_History_SetText:SetFormattedText("%s: %d", HISTORY, bcmDB.lines and bcmDB.lines.ChatFrame1 or 1000)
		linesSetSlider:SetPoint("TOPLEFT", 190, -160)
	end

	--[[ Justify ]]--
	makePanel("BCM_Justify", bcm, "Justify")

	if not bcmDB.BCM_Justify then
		local chatFrameSlider = CreateFrame("Slider", "BCM_Justify_Get", BCM_Justify, "OptionsSliderTemplate")
		chatFrameSlider:SetMinMaxValues(1, 10)
		chatFrameSlider:SetValue(1)
		chatFrameSlider:SetValueStep(1)
		chatFrameSlider:SetScript("OnValueChanged", function(_, v)
			local cF = ("ChatFrame%d"):format(v)
			BCM_Justify_GetText:SetFormattedText("%s: %s", cF, _G[cF].name)
			BCM_Justify_Set:SetValue(bcmDB.justify and ((bcmDB.justify[cF] == "RIGHT" and 3) or (bcmDB.justify[cF] == "CENTER" and 2)) or 1)
			BCM_Justify_SetText:SetText(bcmDB.justify and bcmDB.justify[cF] and BCM[bcmDB.justify[cF]] or BCM.LEFT)
		end)
		BCM_Justify_GetHigh:SetText(10)
		BCM_Justify_GetLow:SetText(1)
		BCM_Justify_GetText:SetFormattedText("ChatFrame1: %s", ChatFrame1.name)
		chatFrameSlider:SetPoint("TOPLEFT", 16, -160)

		local justifyPosition = CreateFrame("Slider", "BCM_Justify_Set", BCM_Justify, "OptionsSliderTemplate")
		justifyPosition:SetMinMaxValues(1, 3)
		justifyPosition:SetValue(bcmDB.justify and ((bcmDB.justify.ChatFrame1 == "RIGHT" and 3) or (bcmDB.justify.ChatFrame1 == "CENTER" and 2)) or 1)
		justifyPosition:SetValueStep(1)
		justifyPosition:SetScript("OnValueChanged", function(_, v)
			if not bcmDB.justify then bcmDB.justify = {} end
			local cF = ("ChatFrame%d"):format(BCM_Justify_Get:GetValue())
			local justify = v == 1 and "LEFT" or v == 2 and "CENTER" or v == 3 and "RIGHT"
			_G[cF]:SetJustifyH(justify)
			if v == 1 then bcmDB.justify[cF] = nil else bcmDB.justify[cF] = justify end
			BCM_Justify_SetText:SetText(BCM[justify])
		end)
		BCM_Justify_SetHigh:SetText(BCM.RIGHT)
		BCM_Justify_SetLow:SetText(BCM.LEFT)
		BCM_Justify_SetText:SetText(bcmDB.justify and bcmDB.justify.ChatFrame1 and BCM[bcmDB.justify.ChatFrame1] or BCM.LEFT)
		justifyPosition:SetPoint("TOPLEFT", 250, -160)
	end

	--[[ Player Names ]]--
	makePanel("BCM_PlayerNames", bcm, "Player Names")

	if not bcmDB.BCM_PlayerNames then
		local onClick = function(frame)
			BCM_Warning:Show()
			if frame:GetChecked() then
				PlaySound("igMainMenuOptionCheckBoxOn")
				if frame:GetName() == "BCM_PlayerLevel_Button" then
					bcmDB.nolevel = nil
				elseif frame:GetName() == "BCM_PlayerColor_Button" then
					bcmDB.noMiscColor = nil
				else
					bcmDB.nogroup = nil
				end
			else
				PlaySound("igMainMenuOptionCheckBoxOff")
				if frame:GetName() == "BCM_PlayerLevel_Button" then
					bcmDB.nolevel = true
				elseif frame:GetName() == "BCM_PlayerColor_Button" then
					bcmDB.noMiscColor = true
				else
					bcmDB.nogroup = true
				end
			end
		end

		local levelsBtn = CreateFrame("CheckButton", "BCM_PlayerLevel_Button", BCM_PlayerNames, "OptionsBaseCheckButtonTemplate")
		levelsBtn:SetScript("OnClick", onClick)
		levelsBtn:SetPoint("TOPLEFT", 16, -140)
		levelsBtn:SetChecked(not bcmDB.nolevel and true)
		local levelsBtnText = levelsBtn:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		levelsBtnText:SetPoint("LEFT", levelsBtn, "RIGHT")
		levelsBtnText:SetText(BCM.SHOWLEVELS)

		local groupBtn = CreateFrame("CheckButton", "BCM_PlayerGroup_Button", BCM_PlayerNames, "OptionsBaseCheckButtonTemplate")
		groupBtn:SetScript("OnClick", onClick)
		groupBtn:SetPoint("TOPLEFT", 16, -170)
		groupBtn:SetChecked(not bcmDB.nogroup and true)
		local groupBtnText = groupBtn:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		groupBtnText:SetPoint("LEFT", groupBtn, "RIGHT")
		groupBtnText:SetText(BCM.SHOWGROUP)

		local colorBtn = CreateFrame("CheckButton", "BCM_PlayerColor_Button", BCM_PlayerNames, "OptionsBaseCheckButtonTemplate")
		colorBtn:SetScript("OnClick", onClick)
		colorBtn:SetPoint("TOPLEFT", 16, -200)
		colorBtn:SetChecked(not bcmDB.noMiscColor and true)
		local colorBtnText = colorBtn:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		colorBtnText:SetPoint("LEFT", colorBtn, "RIGHT")
		colorBtnText:SetText(BCM.COLORMISC)

		if not BCM_PlayerBrackDesc then
			local brackInputText = BCM_PlayerNames:CreateFontString("BCM_PlayerBrackDesc", "ARTWORK", "GameFontNormal")
			brackInputText:SetPoint("TOPLEFT", 16, -240)
			brackInputText:SetText(BCM.PLAYERBRACKETS)
			local brackLInput = CreateFrame("EditBox", "BCM_PlayerLBrack", BCM_PlayerNames, "InputBoxTemplate")
			brackLInput:SetPoint("TOPLEFT", 32, -260)
			brackLInput:SetAutoFocus(false)
			brackLInput:SetWidth(20)
			brackLInput:SetHeight(20)
			brackLInput:SetJustifyH("CENTER")
			brackLInput:SetScript("OnTextChanged", function(frame, changed)
				if changed then bcmDB.playerLBrack = frame:GetText() end
			end)
			brackLInput:SetScript("OnEnterPressed", brackLInput:GetScript("OnEscapePressed"))
			local brackRInput = CreateFrame("EditBox", "BCM_PlayerRBrack", BCM_PlayerNames, "InputBoxTemplate")
			brackRInput:SetPoint("TOPLEFT", 64, -260)
			brackRInput:SetAutoFocus(false)
			brackRInput:SetWidth(20)
			brackRInput:SetHeight(20)
			brackRInput:SetJustifyH("CENTER")
			brackRInput:SetScript("OnTextChanged", function(frame, changed)
				if changed then bcmDB.playerRBrack = frame:GetText() end
			end)
			brackRInput:SetScript("OnEnterPressed", brackRInput:GetScript("OnEscapePressed"))
			local separatorInput = CreateFrame("EditBox", "BCM_PlayerSeparator", BCM_PlayerNames, "InputBoxTemplate")
			separatorInput:SetPoint("TOPLEFT", 96, -260)
			separatorInput:SetAutoFocus(false)
			separatorInput:SetWidth(20)
			separatorInput:SetHeight(20)
			separatorInput:SetJustifyH("CENTER")
			separatorInput:SetScript("OnTextChanged", function(frame, changed)
				if changed then bcmDB.playerSeparator = frame:GetText() end
			end)
			separatorInput:SetScript("OnEnterPressed", separatorInput:GetScript("OnEscapePressed"))
		end
	end

	--[[ Resize ]]--
	makePanel("BCM_Resize", bcm, "Resize")

	--[[ Scroll Down ]]--
	makePanel("BCM_ScrollDown", bcm, "Scroll Down")

	--[[ Sticky ]]--
	makePanel("BCM_Sticky", bcm, "Sticky")

	if not bcmDB.BCM_Sticky then
		local sticky = CreateFrame("Frame", "BCM_Sticky_Drop", BCM_Sticky, "UIDropDownMenuTemplate")
		sticky:SetPoint("TOPLEFT", 16, -140)
		BCM_Sticky_DropText:SetText(GUILD_NEWS_MAKE_STICKY)
		sticky.initialize = function()
			local info = wipe(BCM.info)
			info.func = function(v)
				if ChatTypeInfo[v.value].sticky == 1 then
					ChatTypeInfo[v.value].sticky = 0
					bcmDB.sticky[v.value] = 0
				else
					ChatTypeInfo[v.value].sticky = 1
					bcmDB.sticky[v.value] = 1
				end
			end
			local tbl = {"SAY", "PARTY", "RAID", "GUILD", "OFFICER", "YELL", "WHISPER", "BN_WHISPER", "EMOTE", "RAID_WARNING", "INSTANCE_CHAT", "CHANNEL"}
			for i=1, #tbl do
				info.text = _G[tbl[i]]
				info.value = tbl[i]
				info.checked = ChatTypeInfo[tbl[i]].sticky == 1
				info.isNotRadio = true
				info.keepShownOnClick = 1
				UIDropDownMenu_AddButton(info)
				tbl[i] = nil
			end
			tbl = nil
		end
	end

	--[[ Tell Target ]]--
	makePanel("BCM_TellTarget", bcm, "Tell Target")

	--[[ Timestamp Customize ]]--
	makePanel("BCM_Timestamp", bcm, "Timestamp")

	if not bcmDB.BCM_Timestamp then
		local stampBtn = CreateFrame("CheckButton", "BCM_TimestampColor_Button", BCM_Timestamp, "OptionsBaseCheckButtonTemplate")
		stampBtn:SetScript("OnClick", function(frame)
			local input = BCM_Timestamp_InputCol
			if frame:GetChecked() then
				PlaySound("igMainMenuOptionCheckBoxOn")
				bcmDB.stampcol = "777777"
				input:SetText(bcmDB.stampcol)
				input:EnableMouse(true)
			else
				PlaySound("igMainMenuOptionCheckBoxOff")
				bcmDB.stampcol = ""
				input:SetText(bcmDB.stampcol)
				input:EnableMouse(false)
				input:ClearFocus()
			end
		end)
		stampBtn:SetPoint("TOPLEFT", 16, -140)
		stampBtn:SetHitRectInsets(0, -50, 0, 0)
		local stampBtnText = stampBtn:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		stampBtnText:SetPoint("LEFT", stampBtn, "RIGHT")
		stampBtnText:SetText(COLOR)

		local stampColInput = CreateFrame("EditBox", "BCM_Timestamp_InputCol", BCM_Timestamp, "InputBoxTemplate")
		stampColInput:SetPoint("LEFT", stampBtn, "RIGHT", 60, 0)
		stampColInput:SetAutoFocus(false)
		stampColInput:SetWidth(50)
		stampColInput:SetHeight(20)
		stampColInput:SetMaxLetters(6)
		stampColInput:SetScript("OnTextChanged", function(frame, changed)
			if changed then
				local txt = frame:GetText()
				if txt:find("%X") then frame:SetText(bcmDB.stampcol) return end
				bcmDB.stampcol = txt
			end
		end)
		stampColInput:SetScript("OnEnterPressed", stampColInput:GetScript("OnEscapePressed"))
		local stampColInputText = stampColInput:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		stampColInputText:SetPoint("LEFT", stampColInput, "RIGHT", 10, 0)
		stampColInputText:SetText(">>>   http://bit.ly/bevPp")

		local stampFormatTitle = BCM_Timestamp:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		stampFormatTitle:SetPoint("TOPLEFT", 20, -190)
		stampFormatTitle:SetText(FORMATTING..":")
		local stampFormatText = BCM_Timestamp:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
		stampFormatText:SetPoint("TOPLEFT", 20, -210)
		stampFormatText:SetText("%p == "..TIMEMANAGER_AM.."/"..TIMEMANAGER_PM.."\n%S == "..gsub(D_SECONDS, ".*:(.*);$", "%1").."\n%M == "..gsub(D_MINUTES, ".*:(.*);$", "%1").."\n%I == "..AUCTION_DURATION_ONE.."\n%H == "..AUCTION_DURATION_TWO)
		local stampBrackInput = CreateFrame("EditBox", "BCM_Timestamp_Format", BCM_Timestamp, "InputBoxTemplate")
		stampBrackInput:SetPoint("TOPLEFT", 25, -280)
		stampBrackInput:SetAutoFocus(false)
		stampBrackInput:SetWidth(100)
		stampBrackInput:SetHeight(20)
		stampBrackInput:SetScript("OnTextChanged", function(frame, changed)
			if changed then
				bcmDB.stampfmt = frame:GetText()
			end
		end)
		stampBrackInput:SetScript("OnEnterPressed", stampBrackInput:GetScript("OnEscapePressed"))
	end

	--[[ URLCopy ]]--
	makePanel("BCM_URLCopy", bcm, "URL Copy")

	makePanel = nil
end

