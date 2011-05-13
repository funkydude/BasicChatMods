
--[[     URLCopy Module     ]]--

local _, BCM = ...
BCM.modules[#BCM.modules+1] = function()
	if bcmDB.BCM_URLCopy then return end

	local gsub = gsub
	local filterFunc = function(self, event, msg, ...)
		local newMsg, found = gsub(msg, "http://[%a%-%d]*%.?[%a%-%d]+%.%a%a%a?/%S+", "|cffffffff|Hurl:%1|h[%1]|h|r")
		if found > 0 then return false, newMsg, ... end

		newMsg, found = gsub(msg, "http://[%a%-%d]*%.?[%a%-%d]+%.[%a%-%d]+%.%a%a%a?/%S+", "|cffffffff|Hurl:%1|h[%1]|h|r")
		if found > 0 then return false, newMsg, ... end

		newMsg, found = gsub(msg, "http://[%a%-%d]*%.?[%a%-%d]+%.%a%a%a?/", "|cffffffff|Hurl:%1|h[%1]|h|r")
		if found > 0 then return false, newMsg, ... end

		newMsg, found = gsub(msg, "http://[%a%-%d]*%.?[%a%-%d]+%.[%a%-%d]+%.%a%a%a?/", "|cffffffff|Hurl:%1|h[%1]|h|r")
		if found > 0 then return false, newMsg, ... end

		newMsg, found = gsub(msg, "http://[%a%-%d]*%.?[%a%-%d]+%.%a%a%a?$", "|cffffffff|Hurl:%1|h[%1]|h|r")
		if found > 0 then return false, newMsg, ... end

		newMsg, found = gsub(msg, "http://[%a%-%d]*%.?[%a%-%d]+%.[%a%-%d]+%.%a%a%a?$", "|cffffffff|Hurl:%1|h[%1]|h|r")
		if found > 0 then return false, newMsg, ... end

		newMsg, found = gsub(msg, "(http://[%a%-%d]*%.?[%a%-%d]+%.%a%a%a?) ", "|cffffffff|Hurl:%1|h[%1]|h|r ")
		if found > 0 then return false, newMsg, ... end

		newMsg, found = gsub(msg, "(http://[%a%-%d]*%.?[%a%-%d]+%.[%a%-%d]+%.%a%a%a?) ", "|cffffffff|Hurl:%1|h[%1]|h|r ")
		if found > 0 then return false, newMsg, ... end

		newMsg, found = gsub(msg, "[%a%-%d]*%.?[%a%-%d]+%.%a%a%a?/%S+", "|cffffffff|Hurl:%1|h[%1]|h|r")
		if found > 0 then return false, newMsg, ... end

		newMsg, found = gsub(msg, "[%a%-%d]*%.?[%a%-%d]+%.%a%a%a?/", "|cffffffff|Hurl:%1|h[%1]|h|r")
		if found > 0 then return false, newMsg, ... end

		newMsg, found = gsub(msg, "[%a%-%d]*%.?[%a%-%d]+%.%a%a%a?$", "|cffffffff|Hurl:%1|h[%1]|h|r")
		if found > 0 then return false, newMsg, ... end

		newMsg, found = gsub(msg, "([%a%-%d]*%.?[%a%-%d]+%.%a%a%a?) ", "|cffffffff|Hurl:%1|h[%1]|h|r ")
		if found > 0 then return false, newMsg, ... end

		newMsg, found = gsub(msg, "%d+%.%d+%.%d+%.%d+:?%d*/?%S*", "|cffffffff|Hurl:%1|h[%1]|h|r")
		if found > 0 then return false, newMsg, ... end
	end

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
	local oldShow = ChatFrame_OnHyperlinkShow
	ChatFrame_OnHyperlinkShow = function(self, link, ...)
		if (link):sub(1, 3) == "url" then
			currentLink = (link):sub(5)
			StaticPopup_Show("BCM_URLCopyBox")
			return
		end
		oldShow(self, link, ...)
	end

	--[[ Popup Box ]]--
	StaticPopupDialogs["BCM_URLCopyBox"] = {
		text = "URL",
		button1 = CLOSE,
		hasEditBox = 1,
		editBoxWidth = 350,
		OnShow = function(frame)
			frame.editBox:SetText(currentLink)
			frame.editBox:SetFocus()
			frame.editBox:HighlightText(0)
			currentLink = nil
		end,
		EditBoxOnEscapePressed = function(frame) frame:GetParent():Hide() end,
		timeout = 0,
		whileDead = 1,
		hideOnEscape = 1,
	}
end

