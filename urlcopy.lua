
--[[     URLCopy Module     ]]--

local _, BCM = ...
BCM.modules[#BCM.modules+1] = function()
	if bcmDB.BCM_URLCopy then return end

	local gsub = string.gsub
	local one = "|cffffffff|Hgarrmission:BCMuc:|h[%1]|h|r"
	local two = "%1|cffffffff|Hgarrmission:BCMuc:|h[%2]|h|r"
	-- This functionality used to be stricter and more complex, but with the introduction
	-- of gTLDs of any form or language, we can now reduce the amount of patterns.

	-- Sentences like "I wish.For someone" will become URLs now "[wish.For]", and although they seem
	-- like false positives, they can be genuine.

	-- Easily readable, right? :D
	-- We're converting anything in the form of "word.word" to a URL,
	-- but we're adding a list of excluded symbols such as {}[]` that aren't a valid address, to prevent possible false positives.
	-- Also note that the only difference between the 1st and 2nd section of the pattern is that the 2nd has a few extra
	-- valid (but invalid in their location) things ".", "/", "," to prevent words like "lol...", "true./" and "yes.," becoming a URL.
	-- As of the introduction of the S.E.L.F.I.E camera we now require at least 2 valid letters for example: yo.hi
	local filterFunc = function(_, _, msg, ...)
		-- [ ]url://a.b.cc.dd/e
		local newMsg, found = gsub(msg,
			"( )([^ %%'=%.,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~]+%.[^ %%'=%./,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~:]+%.[^ %%'=%./,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~:]+[^ %%'=%./,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~:]%.[^ %p%c%d][^ %p%c%d]+/[^ \"%^`{}%[%]\\|<>]+)",
			two
		)
		if found > 0 then return false, newMsg, ... end
		-- ^url://a.b.cc.dd/e
		newMsg, found = gsub(msg,
			"^[^ %%'=%.,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~]+%.[^ %%'=%./,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~:]+%.[^ %%'=%./,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~:]+[^ %%'=%./,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~:]%.[^ %p%c%d][^ %p%c%d]+/[^ \"%^`{}%[%]\\|<>]+",
			one
		)
		if found > 0 then return false, newMsg, ... end
		-- [ ]url://a.bb.cc/d
		newMsg, found = gsub(msg,
			"( )([^ %%'=%.,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~]+%.[^ %%'=%./,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~:]+[^ %%'=%./,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~:]%.[^ %p%c%d][^ %p%c%d]+/[^ \"%^`{}%[%]\\|<>]+)",
			two
		)
		if found > 0 then return false, newMsg, ... end
		-- ^url://a.bb.cc/d
		newMsg, found = gsub(msg,
			"^[^ %%'=%.,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~]+%.[^ %%'=%./,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~:]+[^ %%'=%./,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~:]%.[^ %p%c%d][^ %p%c%d]+/[^ \"%^`{}%[%]\\|<>]+",
			one
		)
		if found > 0 then return false, newMsg, ... end
		-- [ ]url://aa.bb/c
		newMsg, found = gsub(msg,
			"( )([^ %%'=%.,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~]+[^ %%'=%./,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~:]%.[^ %p%c%d][^ %p%c%d]+/[^ \"%^`{}%[%]\\|<>]+)",
			two
		)
		if found > 0 then return false, newMsg, ... end
		-- ^url://aa.bb/c
		newMsg, found = gsub(msg,
			"^[^ %%'=%.,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~]+[^ %%'=%./,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~:]%.[^ %p%c%d][^ %p%c%d]+/[^ \"%^`{}%[%]\\|<>]+",
			one
		)
		if found > 0 then return false, newMsg, ... end
		-- [ ]url://a.b.cc.dd
		newMsg, found = gsub(msg,
			"( )([^ %%'=%.,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~]+%.[^ %%'=%./,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~:]+%.[^ %%'=%./,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~:]+[^ %%'=%./,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~:]%.[^ %p%c%d][^ %p%c%d]+)",
			two
		)
		if found > 0 then return false, newMsg, ... end
		-- ^url://a.b.cc.dd
		newMsg, found = gsub(msg,
			"^[^ %%'=%.,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~]+%.[^ %%'=%./,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~:]+%.[^ %%'=%./,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~:]+[^ %%'=%./,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~:]%.[^ %p%c%d][^ %p%c%d]+",
			one
		)
		-- [ ]url://a.bb.cc
		newMsg, found = gsub(msg,
			"( )([^ %%'=%.,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~]+%.[^ %%'=%./,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~:]+[^ %%'=%./,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~:]%.[^ %p%c%d][^ %p%c%d]+)",
			two
		)
		if found > 0 then return false, newMsg, ... end
		-- ^url://a.bb.cc
		newMsg, found = gsub(msg,
			"^[^ %%'=%.,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~]+%.[^ %%'=%./,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~:]+[^ %%'=%./,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~:]%.[^ %p%c%d][^ %p%c%d]+",
			one
		)
		-- [ ]url://aa.bb
		newMsg, found = gsub(msg,
			"( )([^ %%'=%.,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~]+[^ %%'=%./,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~:]%.[^ %p%c%d][^ %p%c%d]+)",
			two
		)
		if found > 0 then return false, newMsg, ... end
		-- ^url://aa.bb
		newMsg, found = gsub(msg,
			"^[^ %%'=%.,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~]+[^ %%'=%./,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~:]%.[^ %p%c%d][^ %p%c%d]+",
			one
		)
		if found > 0 then return false, newMsg, ... end
		newMsg, found = gsub(msg,
			-- Numbers are banned from the first pattern to prevent false positives like "5.5k" etc.
			-- This is our IPv4/v6 pattern at the beggining of a sentence.
			"^%x+[%.:]%x+[%.:]%x+[%.:]%x+[^ \"%^`{}%[%]\\|<>]*",
			one
		)
		
		if found > 0 then return false, newMsg, ... end
		newMsg, found = gsub(msg,
			-- This is our mid-sentence IPv4/v6 pattern, we separate the IP patterns into 2 to prevent
			-- false positives with linking items, spells, etc.
			"( )(%x+[%.:]%x+[%.:]%x+[%.:]%x+[^ \"%^`{}%[%]\\|<>]*)",
			two
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
	ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_WARNING", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT_LEADER", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER_INFORM", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_INLINE_TOAST_BROADCAST", filterFunc)

	hooksecurefunc("SetItemRef", function(link, text)
		local _, bcm = strsplit(":", link)
		if bcm == "BCMuc" then
			text = gsub(text, "^[^%[]+%[(.+)%]|h|r$", "%1")
			BCM:Popup(text)
		end
	end)
end

