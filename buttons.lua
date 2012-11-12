
--[[     Button Hide Module     ]]--

local _, BCM = ...
BCM.modules[#BCM.modules+1] = function()
	if bcmDB.BCM_ButtonHide then return end

	local hideFunc = function(frame) frame:Hide() end
	ChatFrameMenuButton:HookScript("OnShow", hideFunc) --Hide the chat shortcut button for emotes/languages/etc
	ChatFrameMenuButton:Hide() --Hide the chat shortcut button for emotes/languages/etc
	FriendsMicroButton:HookScript("OnShow", hideFunc) --Hide the "Friends Online" count button
	FriendsMicroButton:Hide() --Hide the "Friends Online" count button

	BCM.chatFuncsPerFrame[#BCM.chatFuncsPerFrame+1] = function(n)
		local btnFrame = _G[n.."ButtonFrame"]
		btnFrame:HookScript("OnShow", hideFunc) --Hide the up/down arrows
		btnFrame:Hide() --Hide the up/down arrows
	end
end

