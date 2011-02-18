
--[[     Button Hide Module     ]]--

local _, f = ...
f.functions[#f.functions+1] = function()
	if bcmDB.BCM_ButtonHide then return end

	local hideFunc = function(frame) frame:Hide() end
	ChatFrameMenuButton:SetScript("OnShow", hideFunc) --Hide the chat shortcut button for emotes/languages/etc
	ChatFrameMenuButton:Hide() --Hide the chat shortcut button for emotes/languages/etc
	FriendsMicroButton:SetScript("OnShow", hideFunc) --Hide the "Friends Online" count button
	FriendsMicroButton:Hide() --Hide the "Friends Online" count button

	for i = 1, 10 do
		local btnFrame = _G[format("%s%d%s", "ChatFrame", i, "ButtonFrame")]
		btnFrame:SetScript("OnShow", hideFunc) --Hide the up/down arrows
		btnFrame:Hide() --Hide the up/down arrows
	end
end

