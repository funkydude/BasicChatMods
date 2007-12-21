
--[[		Chat Scroll Module		]]--
local _G = getfenv(0)
local fmt = string.format

local function Scroll()
	if arg1 > 0 then
		if IsShiftKeyDown() then
			this:ScrollToTop()
		elseif IsControlKeyDown() then
			this:PageUp()
		else
			this:ScrollUp()
		end
	elseif arg1 < 0 then
		if IsShiftKeyDown() then
			this:ScrollToBottom()
		elseif IsControlKeyDown() then
			this:PageDown()
		else
			this:ScrollDown()
		end
	end
end

--[[
	~~	Chat Frame Scroll	~~
	This module allows scrolling of the chat frames
	for the selected chat frames only.

	Here we scroll ChatFrame1 and 2 only.
	Change for i = 1,2 to for i = 1, x
	x being the amount of chat frames you want to enable scroll for.
	The max chat frames is 7
	e.g.
	for i = 1, 7 do
]]--

local cf
for i = 1, 2 do
	cf = _G[fmt("%s%d", "ChatFrame", i)]
	cf:SetScript("OnMouseWheel", Scroll)
	cf:EnableMouseWheel(true)
end
cf = nil




