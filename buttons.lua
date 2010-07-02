
--[[		Button Hide Module		]]--

--[[
	If you want to show certain buttons, add "--" in
	front of the line of code to disable hiding it
	e.g. if you want to show the up/down arrows you'd change
	--f.Show = f.Hide --Hide the up/down arrows
	--f:Hide() --Hide the up/down arrows
	So now -- has been added at the start, the line is disabled
]]--

do
	ChatFrameMenuButton.Show = ChatFrameMenuButton.Hide --Hide the chat shortcut button for emotes/languages/etc
	ChatFrameMenuButton:Hide() --Hide the chat shortcut button for emotes/languages/etc
	FriendsMicroButton.Show = FriendsMicroButton.Hide --Hide the "Friends Online" count button
	FriendsMicroButton:Hide() --Hide the "Friends Online" count button

	for i = 1, 10 do
		local f = _G[format("%s%d%s", "ChatFrame", i, "ButtonFrame")]
		f.Show = f.Hide --Hide the up/down arrows
		f:Hide() --Hide the up/down arrows
		_G[format("%s%d", "ChatFrame", i)]:SetClampRectInsets(0,0,0,0) --Allow the chat frame to move to the end of the screen
	end
end

