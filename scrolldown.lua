
--[[     Scrolldown Module     ]]--

local _, BCM = ...
BCM.modules[#BCM.modules+1] = function()
	if bcmDB.BCM_ScrollDown or not GetCVarBool("chatMouseScroll") then return end

	local scrollFunc = function(frame, d)
		if d > 0 then
			if IsShiftKeyDown() then
				frame:ScrollToTop()
			elseif IsControlKeyDown() then
				frame:PageUp()
			--else -- Blizz function does this
			--	frame:ScrollUp()
			end
		elseif d < 0 then
			if IsShiftKeyDown() then
				frame:ScrollToBottom()
			elseif IsControlKeyDown() then
				frame:PageDown()
			--else -- Blizz function does this
			--	frame:ScrollDown()
			end
		end
	end

	BCM.chatFuncsPerFrame[#BCM.chatFuncsPerFrame+1] = function(n)
		local cf = _G[n]
		cf:HookScript("OnMouseWheel", scrollFunc)
	end
end

