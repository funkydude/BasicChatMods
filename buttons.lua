
--[[		Button Hide Module		]]--

do
	ChatFrameMenuButton.Show = ChatFrameMenuButton.Hide
	ChatFrameMenuButton:Hide()

	--3.3.5 compat
	local t = ChatFrameEditBox
	if not t then FriendsMicroButton.Show = FriendsMicroButton.Hide FriendsMicroButton:Hide() end
	t = t and "" or "ButtonFrame"

	for i = 1, 7 do
		local up = _G[format("%s%d%s%s", "ChatFrame", i, t, "UpButton")]
		up.Show = up.Hide
		up:Hide()
		local down = _G[format("%s%d%s%s", "ChatFrame", i, t, "DownButton")]
		down.Show = down.Hide
		down:Hide()
		local bottom = _G[format("%s%d%s%s", "ChatFrame", i, t, "BottomButton")]
		bottom.Show = bottom.Hide
		bottom:Hide()
	end
end

