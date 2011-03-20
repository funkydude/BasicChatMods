
--[[     BNet Color Module     ]]--

local _, f = ...
f.functions[#f.functions+1] = function()
	if bcmDB.BCM_BNetColor then return end

	local newAddMsg = {}
	local changeBNetName = function(misc, id, moreMisc, fakeName)
		local englishClass = select(7, BNGetToonInfo(id))
		if strlen(englishClass) < 2 then return end -- Friend logging off
		local class
		for k,v in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do
			if v == englishClass then class = k break end
		end
		if not class then
			for k,v in pairs(LOCALIZED_CLASS_NAMES_MALE) do
				if v == englishClass then class = k break end
			end
		end
		local tbl = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]
		local color = ("%02x%02x%02x"):format(tbl.r*255, tbl.g*255, tbl.b*255)
		return ("|HBNplayer:%s|k:%s:%s|h[|cFF%s%s|r]"):format(misc, id, moreMisc, color, fakeName)
	end
	local AddMessage = function(frame, text, ...)
		text = text:gsub("|HBNplayer:(.-)|k:(%d-):(.-)|h%[(.-)%]", changeBNetName)
		return newAddMsg[frame:GetName()](frame, text, ...)
	end

	for i = 1, 10 do
		local cF = _G[format("%s%d", "ChatFrame", i)]
		--skip combatlog and frames with no messages registered
		if i ~= 2 and #cF.messageTypeList > 0 then
			newAddMsg[format("%s%d", "ChatFrame", i)] = cF.AddMessage
			cF.AddMessage = AddMessage
		end
	end
end

