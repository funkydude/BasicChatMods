--[[		URLCopy Module		]]--

local url = " |cffffffff|Hurl:"
local one = url.."http://www.%1.%2|h[http://www.%1.%2]|h|r "
local two = url.."%1://%2|h[%1://%2]|h|r "
local three = url.."%1@%2%3%4|h[%1@%2%3%4]|h|r "
local four = url.."%1.%2.%3|h[%1.%2.%3]|h|r "
local five = url.."%1.%2.%3:%4|h[%1.%2.%3:%4]|h|r "
local six = url.."%1.%2|h[%1.%2]|h|r "
local patterns = {
	["www%.([_A-Za-z0-9-]+)%.([_A-Za-z0-9-%.&/]+)%s?"] = one,
	["(%a+)://(%S+)%s?"] = two,
	["([_A-Za-z0-9-%.]+)@([_A-Za-z0-9-]+)(%.+)([_A-Za-z0-9-%.]+)%s?"] = three,
	["([_A-Za-z0-9-]+)%.([_A-Za-z0-9-]+)%.(%S+)%s?"] = four,
	["([_A-Za-z0-9-]+)%.([_A-Za-z0-9-]+)%.(%S+)%:([_0-9-]+)%s?"] = five,
	["([_A-Za-z0-9-]+)%.(%a%a%a)%s?"] = six,
}

local currentLink
local gsub = _G.string.gsub
local pairs = _G.pairs
local sub = _G.string.sub
local ref = _G["SetItemRef"]

local function URL(msg)
	for k, v in pairs(patterns) do
		msg = gsub(msg, k, v)
	end
	return false, msg
end
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", URL)
ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", URL)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", URL)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", URL)
ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", URL)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", URL)
ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", URL)
ChatFrame_AddMessageEventFilter("CHAT_MSG_OFFICER", URL)

local function SetItem(link, ...)
	if sub(link, 1, 3) == "url" then
		currentLink = sub(link, 5)
		StaticPopup_Show("BCMUrlCopyDialog")
		return
	end
	return ref(link, ...)
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
		editBox:SetText(currentLink)
		editBox:SetFocus()
		editBox:HighlightText(0)
		local button = _G[this:GetName().."Button2"]
		button:ClearAllPoints()
		button:SetWidth(200)
		button:SetPoint("CENTER", editBox, "CENTER", 0, -30)
		_G[this:GetName().."AlertIcon"]:Hide()
	end,
	EditBoxOnEscapePressed = function() this:GetParent():Hide() end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = 1,
}
