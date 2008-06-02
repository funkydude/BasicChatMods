
--[[		Settings		]]--
local FONT = "Arial Narrow"


--[[		Chat Font Module		]]--
local media = LibStub("LibSharedMedia-3.0", true)
if not media then return end

for i = 1, NUM_CHAT_WINDOWS do
	_G[format("%s%d", "ChatFrame", i)]:SetFont(media:Fetch("font", FONT), 1)
end

