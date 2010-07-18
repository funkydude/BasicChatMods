
--[[		Button Hide Module		]]--

--[[
	If you want to show certain buttons, add "--" in
	front of the line of code to disable hiding it

	e.g. if you want to show the up/down arrows you'd change:

	f:SetScript("OnShow", hideFunc) --Hide the up/down arrows
	f:Hide() --Hide the up/down arrows

	To:
	--f:SetScript("OnShow", hideFunc) --Hide the up/down arrows
	--f:Hide() --Hide the up/down arrows

	So now -- has been added at the start, the line is disabled
]]--

do
	local hideFunc = function(frame) frame:Hide() end

	ChatFrameMenuButton:SetScript("OnShow", hideFunc) --Hide the chat shortcut button for emotes/languages/etc
	ChatFrameMenuButton:Hide() --Hide the chat shortcut button for emotes/languages/etc
	FriendsMicroButton:SetScript("OnShow", hideFunc) --Hide the "Friends Online" count button
	FriendsMicroButton:Hide() --Hide the "Friends Online" count button

	for i = 1, 10 do
		local f = _G[format("%s%d%s", "ChatFrame", i, "ButtonFrame")]
		f:SetScript("OnShow", hideFunc) --Hide the up/down arrows
		f:Hide() --Hide the up/down arrows
	end
end

