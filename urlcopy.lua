
--[[		URLCopy Module		]]--

--[[
	DO NOT MODIFY
	This module allows you to easily
	copy websites from chat by turning
	them into clickable links.
]]--

local tlds = {
	"[Cc][Oo][Mm]", "[Uu][Kk]", "[Nn][Ee][Tt]", "[Dd][Ee]", "[Ff][Rr]", "[Ee][Ss]",
	"[Bb][Ee]", "[Cc][Cc]", "[Uu][Ss]", "[Kk][Oo]", "[Cc][Hh]", "[Tt][Ww]",
	"[Cc][Nn]", "[Rr][Uu]", "[Gg][Rr]", "[Ii][Tt]", "[Ee][Uu]", "[Tt][Vv]",
	"[Nn][Ll]", "[Hh][Uu]", "[Oo][Rr][Gg]"
}

local gsub = gsub
local filterFunc = function(self, event, msg, ...)
	for i=1, 21 do --Number of TLD's in tlds table
		local newMsg, found = gsub(msg, "(%S-%."..tlds[i].."/?%S*)", "|cffffffff|Hurl:%1|h[%1]|h|r")
		if found > 0 then
			return false, newMsg, ...
		end
	end
	local newMsg, found = gsub(msg, "(%d+%.%d+%.%d+%.%d+:?%d*/?%S*)", "|cffffffff|Hurl:%1|h[%1]|h|r")
	if found > 0 then
		return false, newMsg, ...
	end
end

do
	ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_OFFICER", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_CONVERSATION", filterFunc)

	local currentLink = nil
	ChatFrame_OnHyperlinkShow = function(self, link, text, button)
		if (link):sub(1, 3) == "url" then
			currentLink = (link):sub(5)
			StaticPopup_Show("BCMUrlCopyDialog")
			return
		end
		SetItemRef(link, text, button, self)
	end

	--[[		Popup Box		]]--
	StaticPopupDialogs["BCMUrlCopyDialog"] = {
		text = "URL",
		button2 = TEXT(CLOSE),
		hasEditBox = 1,
		hasWideEditBox = 1,
		showAlert = 1,
		OnShow = function(frame)
			local editBox = _G[frame:GetName().."EditBox"]
			editBox:SetText(currentLink)
			currentLink = nil
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

