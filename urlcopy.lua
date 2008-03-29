--[[		URLCopy Module		]]--

local patterns = {
	{ " www%.([_A-Za-z0-9-]+)%.([_A-Za-z0-9-%.&/]+)%s?", "http://www.%1.%2"},
	{ " (%a+)://(%S+)%s?", "%1://%2"},
	{ " ([_A-Za-z0-9-%.]+)@([_A-Za-z0-9-]+)(%.+)([_A-Za-z0-9-%.]+)%s?", "%1@%2%3%4"},
	{ " ([_A-Za-z0-9-]+)%.([_A-Za-z0-9-]+)%.(%S+)%s?", "%1.%2.%3"},
	{ " ([_A-Za-z0-9-]+)%.([_A-Za-z0-9-]+)%.(%S+)%:([_0-9-]+)%s?", "%1.%2.%3:%4"},
	{ " ([_A-Za-z0-9-]+)%.(%a%a%a)%s?", "%1.%2"},
}

local _G = getfenv(0)
local currentLink
local gsub = _G.string.gsub
local ipairs = _G.ipairs
local fmt = _G.string.format
local sub = _G.string.sub
local cf1 = _G.ChatFrame1.AddMessage
local ref = _G["SetItemRef"]

local style = " |cffffffff|Hurl:%s|h[%s]|h|r "
local function AddMessage(frame, text, ...)
	for i, v in ipairs(patterns) do
		text = gsub(text, v[1], fmt(style, v[2], v[2]))
	end
	return cf1(frame, text, ...)
end
_G.ChatFrame1.AddMessage = AddMessage

local function SetItem(link, text, button)
	if sub(link, 1, 3) == "url" then
		currentLink = sub(link, 5)
		StaticPopup_Show("BCMUrlCopyDialog")
		return
	end
	return ref(link, text, button)
end
_G["SetItemRef"] = SetItem

--[[		Popup Box		]]--
StaticPopupDialogs["BCMUrlCopyDialog"] = {
	text = "URL",
	button2 = TEXT(CLOSE),
	hasEditBox = 1,
	hasWideEditBox = 1,
	showAlert = 1,
	OnShow = function()
		local editBox = _G[this:GetName().."WideEditBox"]
		if editBox then
			editBox:SetText(currentLink)
			editBox:SetFocus()
			editBox:HighlightText(0)
		end
		local button = _G[this:GetName().."Button2"]
		if button then
			button:ClearAllPoints()
			button:SetWidth(200)
			button:SetPoint("CENTER", editBox, "CENTER", 0, -30)
		end
		local icon = _G[this:GetName().."AlertIcon"]
		if icon then icon:Hide() end
	end,
	EditBoxOnEscapePressed = function() this:GetParent():Hide() end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = 1,
}
