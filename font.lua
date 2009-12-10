
do
	if not _G.LibStub then return end

	--[[		Settings		]]--
	local FONT = "Arial Narrow"


	--[[		Chat Font Module		]]--
	local media = _G.LibStub("LibSharedMedia-3.0", true)
	if not media then return end

	for i = 1, 7 do
		_G[format("%s%d", "ChatFrame", i)]:SetFont(media:Fetch("font", FONT), 12)
	end
end

