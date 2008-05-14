--[[		Chat Scroll Module		]]--

local function scroll()
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

for i = 1, NUM_CHAT_WINDOWS do
	local cf = _G[format("%s%d", "ChatFrame", i)]
	cf:SetScript("OnMouseWheel", scroll)
	cf:EnableMouseWheel(true)
end
