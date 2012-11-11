
--[[     Fade Module     ]]--

local _, BCM = ...
BCM.modules[#BCM.modules+1] = function()
	if bcmDB.BCM_Fade then return end

	-- Instead of just changing the global fading variables like we previously did,
	-- we now cleanly securehook the fade out functions and do the fading ourself. This should prevent
	-- any taints involved in passing those previously modified global variables to the UIFade functions,
	-- which have been known to cause taint issues in the past.
	-- This code is basically a replica of the Blizzard code which kills fading right after it's started by Blizz.
	-- The only global variable we modify now is CHAT_TAB_HIDE_DELAY as it's the only way to kill delayed
	-- fadeout of the chatframes, but this should be ok as it's only ever used in a non-secure OnUpdate handler
	-- and is never passed elsewhere.
	hooksecurefunc("FCF_FadeOutChatFrame", function(chatFrame)
		local frameName = chatFrame:GetName()

		for index, value in pairs(CHAT_FRAME_TEXTURES) do
			local object = _G[frameName..value]
			if object:IsShown() then
				UIFrameFadeRemoveFrame(object)
				object:SetAlpha(chatFrame.oldAlpha)
			end
		end
		if chatFrame == FCFDock_GetSelectedWindow(GENERAL_CHAT_DOCK) then
			if GENERAL_CHAT_DOCK.overflowButton:IsShown() then
				UIFrameFadeRemoveFrame(GENERAL_CHAT_DOCK.overflowButton)
				GENERAL_CHAT_DOCK.overflowButton:SetAlpha(0)
			end
		end

		local chatTab = _G[frameName.."Tab"]
		if not chatTab.alerting then
			UIFrameFadeRemoveFrame(chatTab)
			chatTab:SetAlpha(0)
		end

		if not chatFrame.isDocked then
			UIFrameFadeRemoveFrame(chatFrame.buttonFrame)
			chatFrame.buttonFrame:SetAlpha(0.2)
		end
	end)
	hooksecurefunc("FCFTab_UpdateAlpha", function(chatFrame)
		local chatTab = _G[chatFrame:GetName().."Tab"]
		if not chatFrame.hasBeenFaded and not chatTab.alerting then
			chatTab:SetAlpha(0)
		end
	end)
	-- Update alpha for non-docked chat frame tabs
	for i=1, BCM.chatFrames do
		local chatTab = _G[("ChatFrame%dTab"):format(i)]
		chatTab:SetAlpha(0)
	end

	-- Remove the delay between mousing away from the chat frame and the fade starting
	CHAT_TAB_HIDE_DELAY = 0
end

