--[[		Chat Scroll Module		]]--

for i = 1, NUM_CHAT_WINDOWS do
	local cf = _G[("%s%d"):format("ChatFrame", i)]
	cf:SetScript("OnMouseWheel", function()
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
	end)
	cf:EnableMouseWheel(true)
end
