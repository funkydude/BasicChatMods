
--[[     Invite Links Module     ]]--

local _, f = ...
f.functions[#f.functions+1] = function()
	if bcmDB.BCM_InviteLinks then return end

	local triggers = {"[Ii][Nn][Vv][Ii][Tt][Ee]", "[Ii][Nn][Vv] ", "[Ii][Nn][Vv]$"}
	local filterFunc = function(self, event, msg, player, ...)
		for i=1, 3 do
			local newMsg, found = gsub(msg, triggers[i], "|cffFF7256|Hinvite:"..player.."|h[%1]|h|r")
			if found > 0 then
				return false, newMsg, player, ...
			end
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

