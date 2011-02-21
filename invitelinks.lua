
--[[     Invite Links Module     ]]--

local _, f = ...
f.functions[#f.functions+1] = function()
	if bcmDB.BCM_InviteLinks then return end

	local trigger = "[Ii][Nn][Vv][Ii][Tt][Ee]"
	local filterFunc = function(self, event, msg, player, ...)
		local newMsg, found = gsub(msg, trigger, "|cffFF7256|Hinvite:"..player.."|h[%1]|h|r")
		if found > 0 then
			return false, newMsg, player, ...
		end
	end

	ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_OFFICER", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", filterFunc)

	local oldShow = ChatFrame_OnHyperlinkShow
	ChatFrame_OnHyperlinkShow = function(self, link, ...)
		if (link):sub(1, 6) == "invite" then
			if IsAltKeyDown() then
				InviteUnit((link):sub(8))
			end
			return
		end
		oldShow(self, link, ...)
	end
end

