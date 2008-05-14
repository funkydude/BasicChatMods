
--[[		Button Hide Module		]]--
local function hide() this:Hide() end --local function to hide the frame

ChatFrameMenuButton:Hide()
for i = 1, NUM_CHAT_WINDOWS do
	local up = _G[format("%s%d%s", "ChatFrame", i, "UpButton")]
	up:SetScript("OnShow", hide)
	up:Hide()
	local down = _G[format("%s%d%s", "ChatFrame", i, "DownButton")]
	down:SetScript("OnShow", hide)
	down:Hide()
	local bottom = _G[format("%s%d%s", "ChatFrame", i, "BottomButton")]
	bottom:SetScript("OnShow", hide)
	bottom:Hide()
end
