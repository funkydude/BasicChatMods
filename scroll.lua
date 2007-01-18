scmScroll = {}

SCM_DISABLE_MOUSE_SCROLL = nil
SCM_SCROLL_LINES = 1

local _G = getfenv(0)

function scmScroll:Enable()
	if not SCM_DISABLE_MOUSE_SCROLL then
		for i = 1, 7 do
			local cf = _G["ChatFrame"..i]
			cf:SetScript("OnMouseWheel", function() self:Scroll() end)
			cf:EnableMouseWheel(true)
		end
	end
end

function scmScroll:Disable(msg)
	for i = 1, 7 do
		local cf = _G["ChatFrame"..i]
		cf:SetScript("OnMouseWheel", nil)
		cf:EnableMouseWheel(false)
	end
end

function scmScroll:Scroll()
	if arg1 > 0 then
		if IsShiftKeyDown() then
			this:ScrollToTop()
		elseif IsControlKeyDown() then
			this:PageUp()
		else
			for i = 1, SCM_SCROLL_LINES do
				this:ScrollUp()
			end
		end
	elseif arg1 < 0 then
		if IsShiftKeyDown() then
			this:ScrollToBottom()
		elseif IsControlKeyDown() then
			this:PageDown()
		else
			for i = 1, SCM_SCROLL_LINES do
				this:ScrollDown()
			end
		end
	end
end

scmScroll:Enable()

