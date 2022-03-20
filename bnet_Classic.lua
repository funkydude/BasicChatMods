
--[[     BattleNet Module     ]]--

local _, BCM = ...
BCM.modules[#BCM.modules+1] = function()
	if bcmDB.BCM_BNet then bcmDB.noBNetColor = nil return end

	if not bcmDB.playerLBrack then bcmDB.playerLBrack = "[" bcmDB.playerRBrack = "]" bcmDB.playerSeparator = ":" end

	local GetAccountInfoByID = C_BattleNet.GetAccountInfoByID
	local changeBNetName = function(icon, misc, id, moreMisc, fakeName, tag, colon)
		local accountInfoTbl = GetAccountInfoByID(id)
		local battleTag, englishClass = accountInfoTbl.battleTag, accountInfoTbl.gameAccountInfo.className

		if bcmDB.noRealName then -- Replace real name with battle tag if enabled
			fakeName = battleTag:gsub("^(.+)#%d+$", "%1")
		end

		if englishClass and englishClass ~= "" then -- Not playing wow, logging off, etc.
			fakeName = bcmDB.noBNetColor and fakeName or "|cFF"..BCM:GetColor(englishClass, true)..fakeName.."|r" -- Colour name if enabled
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

