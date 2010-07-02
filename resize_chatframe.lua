--[[		Resize Module		]]--
--[[	Allow resizing chatframes to whatever size you wish!	]]

do
	for i = 1, 10 do
		local cf = _G[format("%s%d", "ChatFrame", i)]
		cf:SetMinResize(0,0)
		cf:SetMaxResize(0,0)
	end
end

