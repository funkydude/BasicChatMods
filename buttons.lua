Buttons = {}

local _G = getfenv(0)

function Buttons:Enable()
	local a
	ChatFrameMenuButton:Hide()
	for i = 1, 7 do
		a = _G["ChatFrame"..i.."UpButton"]
		a:SetScript("OnShow", function() this:Hide() end)
		a:Hide()

		a = _G["ChatFrame"..i.."DownButton"]
		a:SetScript("OnShow", function() this:Hide() end)
		a:Hide()

		a = _G["ChatFrame"..i.."BottomButton"]
		a:SetScript("OnShow", function() this:Hide() end)
		a:Hide()
	end
end
function Buttons:Disable()
	local a
	ChatFrameMenuButton:Show()
	for i = 1, 7 do
		a = _G["ChatFrame"..i.."UpButton"]
		a:Show()
		a:SetScript("OnShow", nil)

		a = _G["ChatFrame"..i.."DownButton"]
		a:Show()
		a:SetScript("OnShow", nil)

		a = _G["ChatFrame"..i.."BottomButton"]
		a:Show()
		a:SetScript("OnShow", nil)
	end
end

Buttons:Enable()

