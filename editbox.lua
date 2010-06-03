
--[[		EditBox Module		]]--

--[[
	Move the editbox to the top of the
	chat frame instead of the bottom.

	Change ChatFrame1 to ChatFramex
	x being the number of the ChatFrame
	you want to attach the box to.
	Max chat frames is 7
]]--

do
	--Don't move in 3.3.5
	local eb = ChatFrameEditBox
	if eb then
		eb:ClearAllPoints()
		eb:SetPoint("BOTTOMLEFT",  "ChatFrame1", "TOPLEFT",  -5, 0)
		eb:SetPoint("BOTTOMRIGHT", "ChatFrame1", "TOPRIGHT", 5, 0)
		eb:SetAltArrowKeyMode(false)
	else
		for i =1, 10 do
			_G[format("%s%d%s", "ChatFrame", i, "EditBox")]:SetAltArrowKeyMode(false)
		end
	end
end

