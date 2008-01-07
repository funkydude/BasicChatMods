
--[[		URLCopy Module		]]--

local patterns = {
	{ " www%.([_A-Za-z0-9-]+)%.([_A-Za-z0-9-%.&/]+)%s?", "http://www.%1.%2"},
	{ " (%a+)://(%S+)%s?", "%1://%2"},
	{ " ([_A-Za-z0-9-%.]+)@([_A-Za-z0-9-]+)(%.+)([_A-Za-z0-9-%.]+)%s?", "%1@%2%3%4"},
	{ " ([_A-Za-z0-9-]+)%.([_A-Za-z0-9-]+)%.(%S+)%s?", "%1.%2.%3"},
	{ " ([_A-Za-z0-9-]+)%.([_A-Za-z0-9-]+)%.(%S+)%:([_0-9-]+)%s?", "%1.%2.%3:%4"},
	{ " ([_A-Za-z0-9-]+)%.(%a%a%a)%s?", "%1.%2"},
}

local h = nil
local _G = getfenv(0)
local currentLink
local gsub = string.gsub
local ipairs = ipairs
local fmt = string.format
local sub = string.sub
local hooks = {}
local ref = _G["SetItemRef"]

local style = " |cffffffff|Hurl:%s|h[%s]|h|r "
local function AddMessage(frame, text, ...)
	for i, v in ipairs(patterns) do
		text = gsub(text, v[1], fmt(style, v[2], v[2]))
	end
	return hooks[frame](frame, text, ...)
end

local function StaticPopupUrl(link)
	currentLink = link
	StaticPopup_Show("BCMUrlCopyDialog")
end

local function SetItem(link, text, button)
	if sub(link, 1, 3) == "url" then
		StaticPopupUrl(sub(link, 5))
		return
	end
	return ref(link, text, button)
end

local function Show()
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
	if icon then
		icon:Hide()
	end
end

local function Hide()
	this:GetParent():Hide()
end

--[[		Start Hooks		]]--
h = _G["ChatFrame1"]
hooks[h] = h.AddMessage
h.AddMessage = AddMessage

_G["SetItemRef"] = SetItem
--[[		End Hooks		]]--


--[[		Popup Box		]]--
StaticPopupDialogs["BCMUrlCopyDialog"] = {
	text = "URL",
	button2 = TEXT(CLOSE),
	hasEditBox = 1,
	hasWideEditBox = 1,
	showAlert = 1,
	OnShow = Show,
	EditBoxOnEscapePressed = Hide,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = 1,
}
