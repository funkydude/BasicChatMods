
--[[		Button Hide Module		]]--

do
	ChatFrameMenuButton.Show = ChatFrameMenuButton.Hide
	ChatFrameMenuButton:Hide()

	if ChatFrameEditBox then
		for i = 1, 7 do
			local up = _G[format("%s%d%s", "ChatFrame", i, "UpButton")]
			up.Show = up.Hide
			up:Hide()
			local down = _G[format("%s%d%s", "ChatFrame", i, "DownButton")]
			down.Show = down.Hide
			down:Hide()
			local bottom = _G[format("%s%d%s", "ChatFrame", i, "BottomButton")]
			bottom.Show = bottom.Hide
			bottom:Hide()
		end
	else
		FriendsMicroButton.Show = FriendsMicroButton.Hide FriendsMicroButton:Hide()
		for i = 1, 10 do
			local f = _G[format("%s%d%s", "ChatFrame", i, "ButtonFrame")]
			f.Show = f.Hide
			f:Hide()
		end
	end
end

