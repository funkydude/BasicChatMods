scmButtons = {}

SMC_BUTTONS_SHOW_UP = nil
SMC_BUTTONS_SHOW_DOWN = nil
SMC_BUTTONS_SHOW_BOTTOM = nil

local _G = getfenv(0)

local function hide() this:Hide() end

function scmButtons:Enable()
	local a
	ChatFrameMenuButton:Hide()
	for i = 1, 2 do
		if not SMC_BUTTONS_SHOW_UP then
			a = _G["ChatFrame"..i.."UpButton"]
			a:SetScript("OnShow", hide)
			a:Hide()
		end

		if not SMC_BUTTONS_SHOW_DOWN then
			a = _G["ChatFrame"..i.."DownButton"]
			a:SetScript("OnShow", hide)
			a:Hide()
		end

		if not SMC_BUTTONS_SHOW_BOTTOM then
			a = _G["ChatFrame"..i.."BottomButton"]
			a:SetScript("OnShow", hide)
			a:Hide()
		end
	end
end

scmButtons:Enable()