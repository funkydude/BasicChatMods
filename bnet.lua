
--[[     BNet Color Module     ]]--

local _, f = ...
f.functions[#f.functions+1] = function()
	if bcmDB.BCM_BNetColor then return end

	local newAddMsg = {}
	local changeBNetName = function(misc, id, moreMisc, fakeName)
		local englishClass = select(7, BNGetToonInfo(id))
		if strlen(englishClass) < 2 then return end -- Friend logging off
		local color = f:GetColor(englishClass, true)
		return ("|HBNplayer:%s|k:%s:%s|h[|cFF%s%s|r]"):format(misc, id, moreMisc, color, fakeName)
	end
	local AddMessage = function(frame, text, ...)
		text = text:gsub("|HBNplayer:(%S-)|k:(%d-):(%S-)|h%[(%S-)%]", changeBNetName)
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

