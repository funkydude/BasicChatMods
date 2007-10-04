bcmButtons = {}
local bcmButtons = bcmButtons

local BCM_BUTTONS_SHOW_UP = nil
local BCM_BUTTONS_SHOW_DOWN = nil
local BCM_BUTTONS_SHOW_BOTTOM = nil

local _G = getfenv(0)

local function hide() this:Hide() end

function bcmButtons:Enable()
	local a
	ChatFrameMenuButton:Hide()
	for i = 1, 2 do
		if not BCM_BUTTONS_SHOW_UP then
			a = _G[("%s%d%s"):format("ChatFrame", i, "UpButton")]
			a:SetScript("OnShow", hide)
			a:Hide()
		end

		if not BCM_BUTTONS_SHOW_DOWN then
			a = _G[("%s%d%s"):format("ChatFrame", i, "DownButton")]
			a:SetScript("OnShow", hide)
			a:Hide()
		end

		if not BCM_BUTTONS_SHOW_BOTTOM then
			a = _G[("%s%d%s"):format("ChatFrame", i, "BottomButton")]
			a:SetScript("OnShow", hide)
			a:Hide()
		end
	end
end

bcmButtons:Enable()