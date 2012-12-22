
--[[     BattleNet Module     ]]--

local _, BCM = ...
BCM.modules[#BCM.modules+1] = function()
	bcmDB.BCM_BNetColor = nil --temp
	if bcmDB.BCM_BNet then bcmDB.noBNetColor = nil return end

	if not bcmDB.playerLBrack then bcmDB.playerLBrack = "[" bcmDB.playerRBrack = "]" bcmDB.playerSeparator = ":" end

	local storedName = nil
	if bcmDB.noRealName then
		storedName = {}
		local _, n = BNGetNumFriends()
		for i=1, n do
			local _, _, _, toon, id = BNGetFriendInfo(i)
			storedName[id] = toon
		end
	end
	local changeBNetName = function(icon, misc, id, moreMisc, fakeName, tag, colon)
		local _, charName, _, _, _, _, _, englishClass = BNGetToonInfo(id)
		if charName ~= "" then
			if storedName then storedName[id] = charName end --Store name for logoff events, if enabled
			--Replace real name with charname if enabled
			fakeName = bcmDB.noRealName and charName or fakeName
		else
			--Replace real name with stored charname if enabled, for logoff events
			if bcmDB.noRealName and storedName and storedName[id] then
				fakeName = storedName[id]
				storedName[id] = nil
			end
		end
		if englishClass and englishClass ~= "" then --Friend logging off/Starcraft 2
			fakeName = bcmDB.noBNetColor and fakeName or "|cFF"..BCM:GetColor(englishClass, true)..fakeName.."|r" --Color name if enabled
		end
		if bcmDB.noBNetIcon then --Remove "person" icon if enabled
			icon = icon:gsub("|[Tt][^|]+|[Tt]", "")
		end
		return icon..misc..id..moreMisc..bcmDB.playerLBrack..fakeName..bcmDB.playerRBrack..tag..(colon == ":" and bcmDB.playerSeparator or colon)
	end
	BCM.chatFuncs[#BCM.chatFuncs+1] = function(text)
		text = text:gsub("^(.*)(|HBNplayer:%S-|k:)(%d-)(:%S-|h)%[(%S-)%](|?h?)(:?)", changeBNetName)
		return text
	end
end

