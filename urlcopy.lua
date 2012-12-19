
--[[     URLCopy Module     ]]--

local _, BCM = ...
BCM.modules[#BCM.modules+1] = function()
	if bcmDB.BCM_URLCopy then return end

	-- This functionality used to be stricter and more complex, but with the introduction
	-- of gTLDs of any form or language, we can now simplify it down into 1 pattern.
	-- Sentences like "I wish.For someone" will become URLs now "[wish.For]", and although they seem
	-- like false positives, they can be genuine.
	local filterFunc = function(_, _, msg, ...)
		local newMsg, found = gsub(msg,
			-- Easily readable, right? :D
			-- We're converting anything in the form of "word.word" to a URL,
			-- but we're adding a list of excluded symbols such as {}[]` that aren't a valid
			-- address, to prevent possible false positives.
			-- Also note that the only difference between the 1st and 2nd section of the pattern is that the
			-- 2nd has a period "." to prevent words like "lol..." becoming a URL.
			"[^ \"£%^`¬{}%[%]\\|<>]*[^ %.\"£%^`¬{}%[%]\\|<>]%.[^ %.\"£%^`¬{}%[%]\\|<>][^ \"£%^`¬{}%[%]\\|<>]*",
			"|cffffffff|Hbcmurl~%1|h[%1]|h|r"
		)
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
	ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT_LEADER", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER_INFORM", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_CONVERSATION", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_INLINE_TOAST_BROADCAST", filterFunc)

	local SetHyperlink = ItemRefTooltip.SetHyperlink
	function ItemRefTooltip:SetHyperlink(data, ...)
		local isURL, link = strsplit("~", data)
		if isURL and isURL == "bcmurl" then
			BCM:Popup(link)
		else
			SetHyperlink(self, data, ...)
		end
	end
end

