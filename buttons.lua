
--[[     Button Hide Module     ]]--

local _, BCM = ...
BCM.modules[#BCM.modules+1] = function()
	if bcmDB.BCM_ButtonHide then return end

	local hideFunc = function(frame) frame:Hide() end
	ChatFrameMenuButton:HookScript("OnShow", hideFunc)
	ChatFrameMenuButton:Hide() --Hide the chat shortcut button for emotes/languages/etc
	ChatFrameToggleVoiceDeafenButton:HookScript("OnShow", hideFunc)
	ChatFrameToggleVoiceDeafenButton:Hide() --Hide the voice deafen button
	ChatFrameToggleVoiceMuteButton:HookScript("OnShow", hideFunc)
	ChatFrameToggleVoiceMuteButton:Hide() --Hide the voice mute button
	ChatFrameChannelButton:HookScript("OnShow", hideFunc)
	ChatFrameChannelButton:Hide() --Hide the voice mute button
	if QuickJoinToastButton then
		QuickJoinToastButton:HookScript("OnShow", hideFunc) --Hide the "Friends Online" count button
		QuickJoinToastButton:Hide() --Hide the "Friends Online" count button
	end

	BCM.chatFuncsPerFrame[#BCM.chatFuncsPerFrame+1] = function(_, n)
		local btnFrame = _G[n.."ButtonFrame"]
		btnFrame:HookScript("OnShow", hideFunc) --Hide the up/down arrows
		btnFrame:Hide() --Hide the up/down arrows
	end
end

