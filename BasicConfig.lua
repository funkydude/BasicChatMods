
local _, f = ...
f.functions[#f.functions+1] = function()
	local bcm = CreateFrame("Frame", "BCM", InterfaceOptionsFramePanelContainer)
	bcm.name = "BasicChatMods"
	InterfaceOptions_AddCategory(bcm)
	local title = bcm:CreateFontString("BCM_Title", "ARTWORK", "GameFontNormal")
	title:SetPoint("TOPLEFT", 16, -16)
	title:SetText("A /reload is required for changes to take effect.")
	local buttons = CreateFrame("Frame", "BCM_ButtonHide", bcm)
	buttons.name = "Button Hide"
	buttons.parent = "BasicChatMods"
	InterfaceOptions_AddCategory(buttons)
end

