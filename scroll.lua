bcmScroll = {}
local bcmScroll = bcmScroll

local BCM_DISABLE_MOUSE_SCROLL = nil
local BCM_SCROLL_LINES = 1

local _G = getfenv(0)

function bcmScroll:Enable()
	if not BCM_DISABLE_MOUSE_SCROLL then
		for i = 1, 2 do
			local cf = _G[("%s%d"):format("ChatFrame", i)]
			cf:SetScript("OnMouseWheel", function() self:Scroll() end)
			cf:EnableMouseWheel(true)
		end
	end
end

function bcmScroll:Disable(msg)
	for i = 1, 2 do
		local cf = _G[("%s%d"):format("ChatFrame", i)]
		cf:SetScript("OnMouseWheel", nil)
		cf:EnableMouseWheel(false)
	end
end

function bcmScroll:Scroll()
	if arg1 > 0 then
		if IsShiftKeyDown() then
			this:ScrollToTop()
		elseif IsControlKeyDown() then
			this:PageUp()
		else
			for i = 1, BCM_SCROLL_LINES do
				this:ScrollUp()
			end
		end
	elseif arg1 < 0 then
		if IsShiftKeyDown() then
			this:ScrollToBottom()
		elseif IsControlKeyDown() then
			this:PageDown()
		else
			for i = 1, BCM_SCROLL_LINES do
				this:ScrollDown()
			end
		end
	end
end

bcmScroll:Enable()

