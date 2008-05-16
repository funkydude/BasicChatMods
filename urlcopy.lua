--[[		URLCopy Module		]]--

local hurl = "|cffffffff|Hurl:"
local urlrep = hurl.."%1.%2%3%4|h[%1.%2%3%4]|h|r"
local mailrep = hurl.."%1@%2.%3%4|h[%1@%2.%3%4]|h|r"
local urltrig = "(%S+)%.(%S+)(%.?%S*)(%.?%S*)"
local mailtrig = "(%S+)%@(%S+)%.(%S+)(%.?%S*)"

local currentLink
local gsub = _G.string.gsub
local sub = _G.string.sub
local ref = _G["SetItemRef"]

local prev = 0
local function URL(msg)
	local n
	msg, n = gsub(msg, mailtrig, mailrep)
	if n > 0 then return false, msg end
	msg = gsub(msg, urltrig, urlrep)
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
