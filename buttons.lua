
--[[		Button Hide Module		]]--
local _G = getfenv(0)
local fmt = string.format

local function hide() this:Hide() end --local function to hide the frame

--[[
	~~	Hide the chat buttons	~~
	This module hides the buttons next to the chat frames
	for the selected chat frames only.

	Here we hide buttons from ChatFrame1 and 2 only.
	Change for i = 1,2 to for i = 1, x
	x being the amount of chat frames you want to hide buttons for.
	The max chat frames is 7
	e.g.
	for i = 1, 7 do
]]--


local b --local button variable
ChatFrameMenuButton:Hide()
for i = 1, 2 do
	b = _G[fmt("%s%d%s", "ChatFrame", i, "UpButton")]
	b:SetScript("OnShow", hide)
	b:Hide()

	b = _G[fmt("%s%d%s", "ChatFrame", i, "DownButton")]
	b:SetScript("OnShow", hide)
	b:Hide()

	b = _G[fmt("%s%d%s", "ChatFrame", i, "BottomButton")]
	b:SetScript("OnShow", hide)
	b:Hide()
end
b = nil