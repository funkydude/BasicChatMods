--[[		URLCopy Module		]]--
--[[		DON'T MODIFY		]]--

local currentLink = nil

local gsub = _G.string.gsub
local ipairs = _G.ipairs
local pairs = _G.pairs

local tlds = {
COM = true,
UK = true,
NET = true,
INFO = true,
CO = true,
DE = true,
FR = true,
ES = true,
BE = true,
CC = true,
US = true,
KO = true,
CH = true,
TW = true,
}
local style = "|cffffffff|Hurl:%s|h[%s]|h|r"
local tokennum, matchTable = 1, {}
local function RegisterMatch(text)
	local token = "\255\254\253"..tokennum.."\253\254\255"
	matchTable[token] = strreplace(text, "%", "%%")
	tokennum = tokennum + 1
	return token
end
local function Link(link, ...)
	if not link then
		return ""
	end
	return RegisterMatch((style):format(link, link))
end
local function Link_TLD(link, tld, ...)
	if not link or not tld then
		return ""
	end
	if tlds[strupper(tld)] then
		return RegisterMatch((style):format(link, link))
	else
		return RegisterMatch(link)
	end
end

local patterns = {
		-- X://Y url
	{ pattern = "^(%a[%w%.+-]+://%S+)", matchfunc=Link},
	{ pattern = "%f[%S](%a[%w%.+-]+://%S+)", matchfunc=Link},
		-- www.X.Y url
	{ pattern = "^(www%.[%w_-%%]+%.%S+)", matchfunc=Link},
	{ pattern = "%f[%S](www%.[%w_-%%]+%.%S+)", matchfunc=Link},
		-- X@Y.Z email
	{ pattern = "(%S+@[%w_-%%%.]+%.(%a%a+))", matchfunc=Link_TLD},
		-- X.Y.Z/WWWWW url with path
	{ pattern = "^([%w_-%%%.]+[%w_-%%]%.(%a%a+)/%S+)", matchfunc=Link_TLD},
	{ pattern = "%f[%S]([%w_-%%%.]+[%w_-%%]%.(%a%a+)/%S+)", matchfunc=Link_TLD},
		-- X.Y.Z url
	{ pattern = "^([%w_-%%%.]+[%w_-%%]%.(%a%a+))", matchfunc=Link_TLD},
	{ pattern = "%f[%S]([%w_-%%%.]+[%w_-%%]%.(%a%a+))", matchfunc=Link_TLD},
}

local function filterFunc(self, event, msg, ...)
	for _, v in ipairs(patterns) do
		msg = gsub(msg, v.pattern, v.matchfunc)
	end
	for k,v in pairs(matchTable) do
		msg = gsub(msg, k, v)
		matchTable[k] = nil
	end
	return false, msg, ...
end

do
	local events = {
		"CHAT_MSG_CHANNEL", "CHAT_MSG_YELL",
		"CHAT_MSG_GUILD", "CHAT_MSG_OFFICER",
		"CHAT_MSG_PARTY", "CHAT_MSG_PARTY_LEADER",
		"CHAT_MSG_RAID", "CHAT_MSG_RAID_LEADER",
		"CHAT_MSG_SAY", "CHAT_MSG_WHISPER",
	}
	for _,event in ipairs(events) do
		ChatFrame_AddMessageEventFilter(event, filterFunc)
	end
	wipe(events)

	local ref = _G["SetItemRef"]
	local function SetItem(link, ...)
		if (link):sub(1, 3) == "url" then
			currentLink = (link):sub(5)
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
		OnShow = function(frame)
			local editBox = _G[frame:GetName().."WideEditBox"]
			editBox:SetText(currentLink)
			editBox:SetFocus()
			editBox:HighlightText(0)
			local button = _G[frame:GetName().."Button2"]
			button:ClearAllPoints()
			button:SetWidth(200)
			button:SetPoint("CENTER", editBox, "CENTER", 0, -30)
			_G[frame:GetName().."AlertIcon"]:Hide()
		end,
		EditBoxOnEscapePressed = function(frame) frame:GetParent():Hide() end,
		timeout = 0,
		whileDead = 1,
		hideOnEscape = 1,
	}
end

