--[[		Chat Scroll Module		]]--

do
	local function scroll(frame, d)
		if d > 0 then
			if IsShiftKeyDown() then
				frame:ScrollToTop()
			elseif IsControlKeyDown() then
				frame:PageUp()
			else
				frame:ScrollUp()
			end
		elseif d < 0 then
			if IsShiftKeyDown() then
				frame:ScrollToBottom()
			elseif IsControlKeyDown() then
				frame:PageDown()
			else
				frame:ScrollDown()
			end
		end
	end

	for i = 1, 7 do
		local cf = _G[format("%s%d", "ChatFrame", i)]
		cf:SetScript("OnMouseWheel", scroll)
		cf:EnableMouseWheel(true)
	end
end

