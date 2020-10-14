
--[[     BCM Core     ]]--

local addonName, BCM = ...
BCM.chatFrames, BCM.chatFrameRefs = 10, {}
BCM.earlyModules, BCM.modules, BCM.chatFuncs, BCM.chatFuncsPerFrame, BCM.Events = {}, {}, {}, {}, CreateFrame("Frame")
BCM.Events:SetScript("OnEvent", function(frame, event, ...) if frame[event] then frame[event](frame, ...) end end)

--[[ Common Functions ]]--
function BCM:GetColor(className, isLocal)
	-- For modules that need to class color things
	if isLocal then
		local found
		for k,v in next, LOCALIZED_CLASS_NAMES_FEMALE do
			if v == className then className = k found = true break end
		end
		if not found then
			for k,v in next, LOCALIZED_CLASS_NAMES_MALE do
				if v == className then className = k break end
			end
		end
	end
	local tbl = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[className] or RAID_CLASS_COLORS[className]
	if not tbl then
		-- Seems to be a bug since 5.3 where the friends list is randomly empty and fires friendlist updates with an "Unknown" class.
		return ("%02x%02x%02x"):format(GRAY_FONT_COLOR.r*255, GRAY_FONT_COLOR.g*255, GRAY_FONT_COLOR.b*255)
	end
	local color = ("%02x%02x%02x"):format(tbl.r*255, tbl.g*255, tbl.b*255)
	return color
end

do
	--[[ Start popup creation ]]--
	local frame = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
	frame:SetBackdrop({bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
		tile = true, tileSize = 16, edgeSize = 16,
		insets = {left = 1, right = 1, top = 1, bottom = 1}}
	)
	frame:SetSize(650, 40)
	frame:SetPoint("CENTER", UIParent, "CENTER")
	frame:SetFrameStrata("DIALOG")
	frame:SetClipsChildren(true)
	frame:Hide()

	local editBox = CreateFrame("EditBox", nil, frame)
	editBox:SetFontObject(ChatFontNormal)
	editBox:SetSize(600, 40)
	editBox:SetPoint("LEFT", frame, "LEFT", 10, 0)
	local hide = function(f) f:GetParent():Hide() end
	editBox:SetScript("OnEscapePressed", hide)

	local font = frame:CreateFontString(nil, nil, "GameFontNormal")
	font:Hide()

	local close = CreateFrame("Button", nil, frame)
	close:SetNormalTexture(130832) --"Interface\\Buttons\\UI-Panel-MinimizeButton-Up"
	close:SetPushedTexture(130830) --"Interface\\Buttons\\UI-Panel-MinimizeButton-Down"
	close:SetHighlightTexture(130831) --"Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight"
	close:SetSize(32, 32)
	close:SetPoint("RIGHT", frame, "RIGHT", -5, 0)
	close:SetScript("OnClick", hide)
	--[[ End popup creation ]]--

	-- Avoiding StaticPopup taints by making our own popup, rather that adding to the StaticPopup list
	function BCM:Popup(text)
		font:SetText(text) -- We do this to fix special pipe methods e.g. 5 |4hour:hours; Example: copying /played text
		editBox:SetText(font:GetText())
		editBox:HighlightText(0)
		editBox:GetParent():Show()
	end
end

local tostring = tostring
local EditMessage = function(self)
	-- We can't use #self.elements, for some reason a nil get's added to the table at some point which breaks counting
	local num = self.headIndex
	if num == 0 then
		num = self.maxElements
	end
	local tbl = self.elements[num]
	local text = tbl and tbl.message
	if text then
		text = tostring(text)
		for i=1, #BCM.chatFuncs do
			text = BCM.chatFuncs[i](text)
		end
		self.elements[num].message = text
	end
end
local function ReApplyClamp(self)
	BCM.Events.SetClampRectInsets(self, 0,0,0,0)
end

BCM.Events.ADDON_LOADED = function(frame, addon)
	if addon == addonName then
		--[[ Check Database ]]--
		if type(bcmDB) ~= "table" then
			bcmDB = {}
		end

		--[[ Run Modules ]]--
		for i=1, #BCM.earlyModules do
			BCM.earlyModules[i]()
			BCM.earlyModules[i] = nil
		end

		--[[ Self-Cleanup ]]--
		BCM.earlyModules = nil
		frame.ADDON_LOADED = nil
		BCM.Events:UnregisterEvent("ADDON_LOADED")
	end
end
BCM.Events:RegisterEvent("ADDON_LOADED")

BCM.Events.PLAYER_LOGIN = function(frame)
	--[[ Run Modules ]]--
	for i=1, #BCM.modules do
		BCM.modules[i]()
		BCM.modules[i] = nil
	end

	--[[ Hook Chat Frame ]]--
	for i=1, BCM.chatFrames do
		local n = ("%s%d"):format("ChatFrame", i)

		--Allow arrow keys editing in the edit box
		local eB = _G[n.."EditBox"]
		eB:SetAltArrowKeyMode(false)

		local cF = _G[n]
		BCM.chatFrameRefs[i] = cF
		if i ~= 2 then --skip combatlog
			local num = cF.historyBuffer.headIndex
			if num > 0 then -- Catch up on any lines we missed during the log in process
				for l = 1, num do
					local tbl = cF.historyBuffer.elements[l]
					local text = tbl.message
					if text and text ~= "" then
						text = tostring(text)
						for f=1, #BCM.chatFuncs do
							text = BCM.chatFuncs[f](text)
						end
						cF.historyBuffer.elements[l].message = text
					end
				end
			end
			hooksecurefunc(cF.historyBuffer, "PushFront", EditMessage)
		end

		for j=1, #BCM.chatFuncsPerFrame do
			BCM.chatFuncsPerFrame[j](cF, n, i)
		end
	end

	--[[ Hook On-Demand Chat Frames: BattlePet Log, Whispers, Etc ]]--
	hooksecurefunc("FCF_OpenTemporaryWindow", function()
		for i=(BCM.chatFrames+1), 50 do
			local n = ("%s%d"):format("ChatFrame", i)
			local cF = _G[n]
			if cF then
				BCM.chatFrames = i -- Update the chat frame count for config options
				BCM.chatFrameRefs[i] = cF

				--Allow the chat frame to move to the end of the screen
				cF:SetClampRectInsets(0,0,0,0)
				--Need to re-apply it if the base UI changes it
				hooksecurefunc(cF, "SetClampRectInsets", ReApplyClamp)

				--Allow arrow keys editing in the edit box
				local eB = _G[n.."EditBox"]
				eB:SetAltArrowKeyMode(false)

				hooksecurefunc(cF.historyBuffer, "PushFront", EditMessage)

				--Fire functions to apply to various frames
				for j=1, #BCM.chatFuncsPerFrame do
					BCM.chatFuncsPerFrame[j](cF, n, i)
				end
			else
				return -- No frame found, stop looping and back out.
			end
		end
	end)

	--[[ Self-Cleanup ]]--
	BCM.modules = nil
	frame.PLAYER_LOGIN = nil
	BCM.Events:UnregisterEvent("PLAYER_LOGIN")
end
BCM.Events:RegisterEvent("PLAYER_LOGIN")

--These need to be set before PLAYER_LOGIN
for i=1, BCM.chatFrames do
	local cF = _G[("%s%d"):format("ChatFrame", i)]
	--Allow the chat frame to move to the end of the screen
	cF:SetClampRectInsets(0,0,0,0)
	--Need to re-apply it if the base UI changes it
	hooksecurefunc(cF, "SetClampRectInsets", ReApplyClamp)
end
--Clamp the toast frame to screen to prevent it cutting out
BNToastFrame:SetClampedToScreen(true)

