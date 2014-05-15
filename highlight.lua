
--[[     Highlight Module     ]]--

local _, BCM = ...
BCM.modules[#BCM.modules+1] = function()
	if bcmDB.BCM_Highlight then bcmDB.highlightWord = nil return end

	--[[ Start one-time table creation ]]--
	local _, class = UnitClass("player")
	local color = "|cFF"..BCM:GetColor(class).."%1|r"

	local utf8sub = function(str, start, numChars)
		local currentIndex = start
		while numChars > 0 and currentIndex <= #str do
			local char = string.byte(str, currentIndex)
			if char > 240 then
				currentIndex = currentIndex + 4
			elseif char > 225 then
				currentIndex = currentIndex + 3
			elseif char > 192 then
				currentIndex = currentIndex + 2
			else
				currentIndex = currentIndex + 1
			end
			numChars = numChars -1
		end
		return str:sub(start, currentIndex - 1)
	end

	local pName, myNames = UnitName("player"), {}
	local up, down, count, tally = strupper(pName), strlower(pName), strlenutf8(pName), 1
	myNames[1] = ""
	for i=1, count do
		--Good thing we only need to run this nonsense once
		local len = strlen(utf8sub(up, tally, 1))
		myNames[1] = myNames[1].. "[" ..utf8sub(up, tally, 1).. utf8sub(down, tally, 1).. "]"..(len > 1 and "+" or "")
		tally = tally + len
	end
	myNames[2] = " ".. myNames[1] .."$"
	myNames[3] = "^".. myNames[1] .."$"
	myNames[4] = "^".. myNames[1] .." "
	myNames[1] = " ".. myNames[1] .." "

	if bcmDB.highlightWord then
		up, down, count, tally = strupper(bcmDB.highlightWord), strlower(bcmDB.highlightWord), strlenutf8(bcmDB.highlightWord), 1
		myNames[5] = ""
		for i=1, count do
			local len = strlen(utf8sub(up, tally, 1))
			myNames[5] = myNames[5].. "[" ..utf8sub(up, tally, 1).. utf8sub(down, tally, 1).. "]"..(len > 1 and "+" or "")
			tally = tally + len
		end
		myNames[6] = " ".. myNames[5] .."$"
		myNames[7] = "^".. myNames[5] .."$"
		myNames[8] = "^".. myNames[5] .." "
		myNames[5] = " ".. myNames[5] .." "
	end
	utf8sub = nil
	--[[ End one-time table creation ]]--

	local gsub, UnitIsUnit, Ambiguate = gsub, UnitIsUnit, Ambiguate
	local filterFunc = function(_, _, msg, player, ...)
		local trimmedPlayer = Ambiguate(player, "none")
		if not UnitIsUnit("player", trimmedPlayer) then
			for i=1, #myNames do
				local newMsg, found = gsub(msg, myNames[i], color)
				if found > 0 then
					PlaySoundFile("Sound\\interface\\iTellMessage.wav", "Master")
					return false, newMsg, player, ...
				end
			end
		end
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
end

