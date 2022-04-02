
--[[     Fade Module     ]]--

local _, BCM = ...
BCM.modules[#BCM.modules+1] = function()
	if bcmDB.BCM_Fade then return end

	local LCA = LibStub("LibChatAnims")
	local storedFuncs = {}
	local values = {0}
	-- Instead of just changing the global fading variables like we previously did,
	-- we now cleanly securehook and do the fading ourself. This should prevent
	-- any taints involved in passing those previously modified global variables to the UIFade functions,
	-- which have been known to cause taint issues in the past.
	-- This code is basically a replica of the Blizzard code which kills fading right after it's started by Blizz.

	local function CorrectAlphaValuesTextures(self)
		if self:IsShown() then
			local SetAlpha, frameValue = storedFuncs[self][1], storedFuncs[self][2]
			if SetAlpha then
				local parent = self:GetParent()
				local alpha = parent.oldAlpha or parent:GetParent().oldAlpha or 0.25
				if values[frameValue] == 0 then
					SetAlpha(self, alpha)
				else
					SetAlpha(self, max(alpha, 0.25))
				end
			end
		end
	end
	local function CorrectAlphaValues(self)
		if self:IsShown() then
			local SetAlpha, frameValue = storedFuncs[self][1], storedFuncs[self][2]
			if SetAlpha then
				SetAlpha(self, values[frameValue])
			end
		end
	end
	local function CorrectAlphaValuesScroll(self)
		if self:IsShown() then
			local SetAlpha, frameValue = storedFuncs[self][1], storedFuncs[self][2]
			if SetAlpha then
				if values[frameValue] == 1 then
					SetAlpha(self, 1)
				elseif self:GetParent().AtBottom and self:GetParent():AtBottom() then
					SetAlpha(self, values[frameValue])
				end
			end
		end
	end
	local function CorrectAlphaValuesTab(self)
		if self:IsShown() then
			local SetAlpha, frameValue = storedFuncs[self][1], storedFuncs[self][2]
			if SetAlpha then
				if values[frameValue] == 1 or self.alerting or LCA:IsAlerting(self) then
					SetAlpha(self, 1)
				else
					SetAlpha(self, values[frameValue])
				end
			end
		end
	end

	local GENERAL_CHAT_DOCK = GENERAL_CHAT_DOCK
	local CHAT_FRAME_TEXTURES = CHAT_FRAME_TEXTURES
	do
		local object = GENERAL_CHAT_DOCK.overflowButton
		if object then
			storedFuncs[object] = {object.SetAlpha, 1}
			hooksecurefunc(object, "SetAlpha", CorrectAlphaValues)
		end
	end

	local function FadeFunc(chatFrame)
		local frameName = chatFrame:GetName()
		for i = 1, #CHAT_FRAME_TEXTURES do
			local object = _G[frameName..CHAT_FRAME_TEXTURES[i]]
			if object:IsShown() then
				CorrectAlphaValuesTextures(object)
			end
		end
		if chatFrame == GENERAL_CHAT_DOCK.selected then
			local id = chatFrame:GetID()
			for i = 1, #GENERAL_CHAT_DOCK.DOCKED_CHAT_FRAMES do
				local frame = GENERAL_CHAT_DOCK.DOCKED_CHAT_FRAMES[i]
				if frame ~= chatFrame then
					local frameId = frame:GetID()
					values[frameId] = values[id]
					FadeFunc(frame)
				end
			end
			storedFuncs[GENERAL_CHAT_DOCK.overflowButton][2] = id
			CorrectAlphaValues(GENERAL_CHAT_DOCK.overflowButton)
		end

		local chatTab = _G[frameName.."Tab"]
		CorrectAlphaValuesTab(chatTab)

		--Fade in the button frame
		if not chatFrame.isDocked then
			CorrectAlphaValues(chatFrame.buttonFrame)
		end

		local object = chatFrame.ScrollBar
		if object then
			CorrectAlphaValuesScroll(object)
		end

		object = chatFrame.ScrollToBottomButton
		if object then
			CorrectAlphaValuesScroll(object)
		end
	end

	local f = CreateFrame("Frame")
	local refs = BCM.chatFrameRefs
	BCM.chatFuncsPerFrame[#BCM.chatFuncsPerFrame+1] = function(chatFrame, _, n)
		values[n] = 0
		local frameName = chatFrame:GetName()
		for i = 1, #CHAT_FRAME_TEXTURES do
			local value = CHAT_FRAME_TEXTURES[i]
			local object = _G[frameName..value]
			storedFuncs[object] = {object.SetAlpha, n}
			hooksecurefunc(object, "SetAlpha", CorrectAlphaValuesTextures)
		end

		local chatTab = _G[frameName.."Tab"]
		storedFuncs[chatTab] = {chatTab.SetAlpha, n}
		hooksecurefunc(chatTab, "SetAlpha", CorrectAlphaValuesTab)

		local object = chatFrame.buttonFrame
		if object then
			storedFuncs[object] = {object.SetAlpha, n}
			hooksecurefunc(object, "SetAlpha", CorrectAlphaValues)
		end

		object = chatFrame.ScrollBar
		if object then
			storedFuncs[object] = {object.SetAlpha, n}
			hooksecurefunc(object, "SetAlpha", CorrectAlphaValuesScroll)
		end

		object = chatFrame.ScrollToBottomButton
		if object then
			storedFuncs[object] = {object.SetAlpha, n}
			hooksecurefunc(object, "SetAlpha", CorrectAlphaValuesScroll)
		end

		if n == 10 then
			for i = 1, 9 do
				local frame = refs[i]
				FadeFunc(frame)
			end
			FadeFunc(chatFrame)
			f:Show()
		elseif n > 10 then
			FadeFunc(chatFrame)
		end
	end

	local CombatLogQuickButtonFrame_Custom = CombatLogQuickButtonFrame_Custom
	f:Hide()
	-- We are competing with FCF_OnUpdate (from where this code is copied)
	f:SetScript("OnUpdate", function()
		for i=1, BCM.chatFrames do
			local chatFrame = refs[i]
			if chatFrame:IsShown() then
				local topOffset = 28
				if i == 2 then
					topOffset = topOffset + CombatLogQuickButtonFrame_Custom:GetHeight()
				end
				--Items that will always cause the frame to fade in.
				if ( MOVING_CHATFRAME or chatFrame.ResizeButton:GetButtonState() == "PUSHED" or
					(chatFrame.isDocked and GENERAL_CHAT_DOCK.overflowButton.list:IsShown()) or
					(chatFrame.ScrollBar and chatFrame.ScrollBar:IsDraggingThumb())) then
					if values[i] == 0 then
						values[i] = 1
						FadeFunc(chatFrame)
					end
				--Things that will cause the frame to fade in if the mouse is stationary.
				elseif (chatFrame:IsMouseOver(topOffset, -2, -2, 2) or --This should be slightly larger than the hit rect insets to give us some wiggle room.
					(chatFrame.isDocked and QuickJoinToastButton:IsMouseOver()) or
					(chatFrame.ScrollBar and (chatFrame.ScrollBar:IsDraggingThumb() or chatFrame.ScrollBar:IsMouseOver())) or
					(chatFrame.ScrollToBottomButton and chatFrame.ScrollToBottomButton:IsMouseOver()) or
					(chatFrame.buttonFrame:IsMouseOver())) then
					if values[i] == 0 then
						values[i] = 1
						FadeFunc(chatFrame)
					end
				elseif values[i] ~= 0 then
					values[i] = 0
					FadeFunc(chatFrame)
				end
			end
		end
	end)
end

