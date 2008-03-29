
--[[		Button Hide Module		]]--
local _G = getfenv(0)
local fmt = string.format

ChatFrameMenuButton:Hide()
for i = 1, 7 do
	_G[fmt("%s%d%s", "ChatFrame", i, "UpButton")]:Hide()
	_G[fmt("%s%d%s", "ChatFrame", i, "DownButton")]:Hide()
	_G[fmt("%s%d%s", "ChatFrame", i, "BottomButton")]:Hide()
end
fmt = nil
