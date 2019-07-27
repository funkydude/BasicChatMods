
--[[     Fade Module     ]]--

local _, BCM = ...
BCM.modules[#BCM.modules+1] = function()
	if bcmDB.BCM_Fade then return end

	local storedFuncs = {}
	local master = 0
	-- Instead of just changing the global fading variables like we previously did,
	-- we now cleanly securehook and do the fading ourself. This should prevent
	-- any taints involved in passing those previously modified global variables to the UIFade functions,
	-- which have been known to cause taint issues in the past.
	-- This code is basically a replica of the Blizzard code which kills fading right after it's started by Blizz.

	local function CorrectAlphaValuesTextures(self)
		if self:IsShown() then
			local SetAlpha = storedFuncs[self]
			if SetAlpha then
				local parent = self:GetParent()
				local alpha = parent.oldAlpha or parent:GetParent().oldAlpha
				if master == 0 then
					SetAlpha(self, alpha)
				else
					SetAlpha(self, max(alpha, 0.25))
				end
			end
		end
	end
	local function CorrectAlphaValues(self)
		if self:IsShown() then
			local SetAlpha = storedFuncs[self]
			if SetAlpha then
				SetAlpha(self, master)
			end
		end
	end
	local function CorrectAlphaValuesScroll(self)
		if self:IsShown() then
			local SetAlpha = storedFuncs[self]
			if SetAlpha then
				if master == 1 then
					SetAlpha(self, master)
				elseif self:GetParent().AtBottom and self:GetParent():AtBottom() then
					SetAlpha(self, master)
				end
			end
		end
	end
	local function CorrectAlphaValuesTab(self)
		if self:IsShown() then
			local SetAlpha = storedFuncs[self]
			if SetAlpha then
				if master == 1 or self.alerting then
					SetAlpha(self, 1)
				else
					SetAlpha(self, master)
				end
			end
		end
	end

	local GENERAL_CHAT_DOCK = GENERAL_CHAT_DOCK
	local CHAT_FRAME_TEXTURES = CHAT_FRAME_TEXTURES
	local object = GENERAL_CHAT_DOCK.overflowButton
	if object then
		storedFuncs[object] = object.SetAlpha
		hooksecurefunc(object, "SetAlpha", CorrectAlphaValues)
	end

	BCM.chatFuncsPerFrame[#BCM.chatFuncsPerFrame+1] = function(chatFrame)
		local frameName = chatFrame:GetName()
		for i = 1, #CHAT_FRAME_TEXTURES do
			local value = CHAT_FRAME_TEXTURES[i]
			local object = _G[frameName..value]
			storedFuncs[object] = object.SetAlpha
			hooksecurefunc(object, "SetAlpha", CorrectAlphaValuesTextures)
		end

		local chatTab = _G[frameName.."Tab"]
		storedFuncs[chatTab] = chatTab.SetAlpha
		hooksecurefunc(chatTab, "SetAlpha", CorrectAlphaValuesTab)

		object = chatFrame.buttonFrame
		if object then
			storedFuncs[object] = object.SetAlpha
			hooksecurefunc(object, "SetAlpha", CorrectAlphaValues)
		end

		object = chatFrame.ScrollBar
		if object then
			storedFuncs[object] = object.SetAlpha
			hooksecurefunc(object, "SetAlpha", CorrectAlphaValuesScroll)
		end

		object = chatFrame.ScrollToBottomButton
		if object then
			storedFuncs[object] = object.SetAlpha
			hooksecurefunc(object, "SetAlpha", CorrectAlphaValuesScroll)
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
			for i = 1, #GENERAL_CHAT_DOCK.DOCKED_CHAT_FRAMES do
				local frame = GENERAL_CHAT_DOCK.DOCKED_CHAT_FRAMES[i]
				if frame ~= chatFrame then
					FadeFunc(frame)
				end
			end
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

	local refs = BCM.chatFrameRefs
	local CombatLogQuickButtonFrame_Custom = CombatLogQuickButtonFrame_Custom
	local f = CreateFrame("Frame")
	f:Show()
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
					if master == 0 then
						master = 1
						FadeFunc(chatFrame)
					end
				--Things that will cause the frame to fade in if the mouse is stationary.
				elseif (chatFrame:IsMouseOver(topOffset, -2, -2, 2) or --This should be slightly larger than the hit rect insets to give us some wiggle room.
					(chatFrame.isDocked and QuickJoinToastButton:IsMouseOver()) or
					(chatFrame.ScrollBar and (chatFrame.ScrollBar:IsDraggingThumb() or chatFrame.ScrollBar:IsMouseOver())) or
					(chatFrame.ScrollToBottomButton and chatFrame.ScrollToBottomButton:IsMouseOver()) or
					(chatFrame.buttonFrame:IsMouseOver())) then
					if master == 0 then
						master = 1
						FadeFunc(chatFrame)
					end
				elseif chatFrame:IsShown() and master == 1 then
					master = 0
					FadeFunc(chatFrame)
				end
			end
		end
	end)
end

