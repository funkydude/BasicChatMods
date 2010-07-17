
--[[		Don't Disable Module		]]--

--[[
	Provides misc functions and
	should not be disabled.
]]--

do
	for i = 1, 10 do
		--Allow resizing chatframes to whatever size you wish!
		local cf = _G[format("%s%d", "ChatFrame", i)]
		cf:SetMinResize(0,0)
		cf:SetMaxResize(0,0)

		--Allow the chat frame to move to the end of the screen
		cf:SetClampRectInsets(0,0,0,0)

		--Allow arrow keys editing in the edit box
		local eb =  _G[format("%s%d%s", "ChatFrame", i, "EditBox")]
		eb:SetAltArrowKeyMode(false)
	end
end

